import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/hunt.dart';
import '../providers/location_providers.dart';
import '../widgets/gameplay_hud.dart';
import '../widgets/gameplay_status_card.dart';

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
                myLocationButtonEnabled: false,
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

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: GameplayHUD(
              riddle: widget.hunt.riddle,
              revealedHints: _revealedHints,
              totalHints: widget.hunt.hints.length,
              hasImage: widget.hunt.imageUrl != null,
              onShowHint: _showHint,
              onShowImage: _showImage,
            ),
          ),

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

                return GameplayStatusCard(
                  isCompleted: _isCompleted,
                  distance: distance,
                  onBack: () => Navigator.pop(context),
                );
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

  void _onHuntCompleted() {
    setState(() {
      _isCompleted = true;
    });
  }
}
