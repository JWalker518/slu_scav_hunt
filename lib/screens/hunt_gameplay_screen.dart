import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/hunt.dart';
import '../providers/location_providers.dart';

class HuntGameplayScreen extends ConsumerStatefulWidget {
  final Hunt hunt;

  const HuntGameplayScreen({super.key, required this.hunt});

  @override
  ConsumerState<HuntGameplayScreen> createState() => _HuntGameplayScreenState();
}

class _HuntGameplayScreenState extends ConsumerState<HuntGameplayScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  bool _isCompleted = false;
  static const double completionRadius = 30.0; // meters

  @override
  Widget build(BuildContext context) {
    final positionAsync = ref.watch(positionStreamProvider);
    final initialPositionAsync = ref.watch(currentPositionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hunting: ${widget.hunt.title}'),
      ),
      body: Stack(
        children: [
          // The Map
          initialPositionAsync.when(
            data: (initialPosition) => GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: initialPosition != null 
                    ? LatLng(initialPosition.latitude, initialPosition.longitude)
                    : LatLng(widget.hunt.coordinates.latitude, widget.hunt.coordinates.longitude),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              // We don't show the target marker to keep it a mystery!
              markers: const {},
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),

          // HUD / Overlay
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: Colors.white.withValues(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'The Riddle',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.hunt.riddle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Completion Status
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: positionAsync.when(
              data: (position) {
                final distance = Geolocator.distanceBetween(
                  position.latitude,
                  position.longitude,
                  widget.hunt.coordinates.latitude,
                  widget.hunt.coordinates.longitude,
                );

                if (distance <= completionRadius && !_isCompleted) {
                  _onHuntCompleted();
                }

                return _buildStatusCard(distance);
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Tracking location...'),
                    ],
                  ),
                ),
              ),
              error: (err, stack) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: $err'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(double distance) {
    final theme = Theme.of(context);
    final isNear = distance < 100;

    return Card(
      color: _isCompleted ? Colors.green : (isNear ? Colors.orange : theme.cardColor),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isCompleted) ...[
              const Icon(Icons.check_circle, color: Colors.white, size: 48),
              const SizedBox(height: 8),
              const Text(
                'CORRECT! YOU FOUND IT!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Discovery'),
              ),
            ] else ...[
              Text(
                isNear ? 'You are very close!' : 'Keep searching...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isNear ? Colors.white : theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Distance: ${distance.toInt()}m',
                style: TextStyle(
                  color: isNear ? Colors.white70 : theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onHuntCompleted() {
    setState(() {
      _isCompleted = true;
    });
    // Optional: Add haptic feedback or sound here
  }
}
