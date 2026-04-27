import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerCard extends StatelessWidget {
  final LatLng? selectedLocation;
  final VoidCallback onPickLocation;

  const LocationPickerCard({
    super.key,
    required this.selectedLocation,
    required this.onPickLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.location_on,
          color: selectedLocation != null ? Colors.green : Colors.grey,
        ),
        title: Text(selectedLocation == null
            ? 'No location selected'
            : 'Location Set: ${selectedLocation!.latitude.toStringAsFixed(4)}, ${selectedLocation!.longitude.toStringAsFixed(4)}'),
        trailing: TextButton(
          onPressed: onPickLocation,
          child: Text(selectedLocation == null ? 'PICK LOCATION' : 'CHANGE'),
        ),
      ),
    );
  }
}
