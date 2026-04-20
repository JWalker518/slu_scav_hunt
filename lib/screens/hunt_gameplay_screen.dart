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
  int _revealedHints = 0;

  void _showHint() {
    if (_revealedHints < widget.hunt.hints.length) {
      setState(() {
        _revealedHints++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hint $_revealedHints: ${widget.hunt.hints[_revealedHints - 1]}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No more hints available!')),
      );
    }
  }

  void _showImage() {
    if (widget.hunt.imageUrl != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Image.network(
            widget.hunt.imageUrl!,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) => const Text('Could not load image'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ],
        ),
      );
    }
  }

  void _reportHunt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Hunt'),
        content: const Text('Are you sure you want to report this hunt for inappropriate content?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              // In a real app, this would send a report to the backend
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hunt reported. Thank you.')),
              );
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final positionAsync = ref.watch(positionStreamProvider);
    final initialPositionAsync = ref.watch(currentPositionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hunting: ${widget.hunt.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.report_problem, color: Colors.orange),
            onPressed: _reportHunt,
            tooltip: 'Report Hunt',
          ),
        ],
      ),
      body: Stack(
        children: [
          // The Map
          initialPositionAsync.when(
            data: (initialPosition) {
              final currentPos = positionAsync.value;
              return GoogleMap(
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
                myLocationButtonEnabled: false, // We'll use our own FAB
                // Explicitly add a marker for the user's location
                markers: currentPos != null ? {
                  Marker(
                    markerId: const MarkerId('user_location'),
                    position: LatLng(currentPos.latitude, currentPos.longitude),
                    infoWindow: const InfoWindow(title: 'You are here'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                  ),
                } : {},
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),

          // HUD / Overlay
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Card(
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.hunt.hints.isNotEmpty)
                      ElevatedButton.icon(
                        onPressed: _showHint,
                        icon: const Icon(Icons.lightbulb),
                        label: Text('Hint ($_revealedHints/${widget.hunt.hints.length})'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[100],
                          foregroundColor: Colors.amber[900],
                        ),
                      ),
                    if (widget.hunt.imageUrl != null) ...[
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _showImage,
                        icon: const Icon(Icons.image),
                        label: const Text('View Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[100],
                          foregroundColor: Colors.blue[900],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final currentPos = positionAsync.value;
          if (currentPos != null) {
            final controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(currentPos.latitude, currentPos.longitude),
              ),
            );
          }
        },
        child: const Icon(Icons.my_location),
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

            // Checks if the hunt is finished
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


  // Updates the app live to indicate that the hunt was completed
  void _onHuntCompleted() {
    setState(() {
      _isCompleted = true;
    });
    // Optional: Add haptic feedback or sound here
  }
}
