import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hunt.dart';
import '../providers/hunt_providers.dart';
import '../providers/auth_providers.dart';
import '../services/privacy_service.dart';
import 'map_picker_screen.dart';

class HuntCreationScreen extends ConsumerStatefulWidget {
  const HuntCreationScreen({super.key});

  @override
  ConsumerState<HuntCreationScreen> createState() => _HuntCreationScreenState();
}

class _HuntCreationScreenState extends ConsumerState<HuntCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _riddleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final List<TextEditingController> _hintControllers = [];
  String _difficulty = 'Normal';
  LatLng? _selectedLocation;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _riddleController.dispose();
    _imageUrlController.dispose();
    for (var controller in _hintControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addHint() {
    setState(() {
      _hintControllers.add(TextEditingController());
    });
  }

  void _removeHint(int index) {
    setState(() {
      _hintControllers[index].dispose();
      _hintControllers.removeAt(index);
    });
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(initialLocation: _selectedLocation),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map')),
      );
      return;
    }

    // Check Privacy Zones
    final restrictedAreaName = PrivacyService.isLocationRestricted(_selectedLocation!);
    if (restrictedAreaName != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location is restricted: $restrictedAreaName')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateProvider).value;
      final huntService = ref.read(huntServiceProvider);

      final hints = _hintControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final newHunt = Hunt(
        id: '', // Firestore will generate the ID
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        riddle: _riddleController.text.trim(),
        difficulty: _difficulty,
        creatorName: user?.displayName ?? user?.email ?? 'Anonymous',
        creatorId: user?.uid ?? '',
        rating: 5.0, // Default rating for new hunts
        coordinates: GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude),
        hints: hints,
        imageUrl: _imageUrlController.text.trim().isNotEmpty 
            ? _imageUrlController.text.trim() 
            : null,
      );

      await huntService.createHunt(newHunt);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hunt created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating hunt: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Hunt')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _riddleController,
                    decoration: const InputDecoration(labelText: 'The Riddle'),
                    maxLines: 2,
                    validator: (value) => value!.isEmpty ? 'Enter the riddle' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL (Optional)',
                      hintText: 'https://example.com/image.jpg',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _difficulty,
                    decoration: const InputDecoration(labelText: 'Difficulty'),
                    items: ['Easy', 'Normal', 'Hard']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (value) => setState(() => _difficulty = value!),
                  ),
                  const SizedBox(height: 24),
                  const Text('Hints', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ..._hintControllers.asMap().entries.map((entry) {
                    int idx = entry.key;
                    TextEditingController controller = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(labelText: 'Hint ${idx + 1}'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeHint(idx),
                        ),
                      ],
                    );
                  }).toList(),
                  TextButton.icon(
                    onPressed: _addHint,
                    icon: const Icon(Icons.add),
                    label: const Text('ADD HINT'),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on, 
                        color: _selectedLocation != null ? Colors.green : Colors.grey,
                      ),
                      title: Text(_selectedLocation == null 
                        ? 'No location selected' 
                        : 'Location Set: ${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}'),
                      trailing: TextButton(
                        onPressed: _pickLocation,
                        child: Text(_selectedLocation == null ? 'PICK LOCATION' : 'CHANGE'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('CREATE HUNT', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
