import 'package:flutter/material.dart';

class LocationRationaleDialog extends StatelessWidget {
  final bool isBackground;

  const LocationRationaleDialog({
    super.key,
    this.isBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isBackground ? 'Background Location Access' : 'Location Access Needed'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBackground ? Icons.explore_outlined : Icons.location_on,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            isBackground
                ? 'This app collects location data to enable tracking your progress in scavenger hunts even when the app is closed or not in use. This allows us to notify you when you reach a target location.'
                : 'This app needs access to your location to show your position on the map and track your progress during the scavenger hunt.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('CONTINUE'),
        ),
      ],
    );
  }
}
