import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hunt.dart';
import '../providers/hunt_providers.dart';
import '../providers/auth_providers.dart';
import '../services/privacy_service.dart';
import '../widgets/hint_input_list.dart';
import '../widgets/location_picker_card.dart';
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
  bool _showDistance = true;
  LatLng? _selectedLocation;

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

    final restrictedAreaName = PrivacyService.isLocationRestricted(_selectedLocation!);
    if (restrictedAreaName != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location is restricted: $restrictedAreaName')),
      );
      return;
    }

    final user = ref.read(authStateProvider).value;
    final hints = _hintControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    final newHunt = Hunt(
      id: '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      riddle: _riddleController.text.trim(),
      difficulty: _difficulty,
      creatorName: user?.displayName ?? user?.email ?? 'Anonymous',
      creatorId: user?.uid ?? '',
      rating: 5.0,
      coordinates: GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude),
      hints: hints,
      imageUrl: _imageUrlController.text.trim().isNotEmpty 
          ? _imageUrlController.text.trim() 
          : null,
      showDistance: _showDistance,
    );

    await ref.read(huntControllerProvider.notifier).createHunt(newHunt);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(huntControllerProvider, (previous, next) {
      if (!next.isLoading && next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating hunt: ${next.error}')),
        );
      } else if (!next.isLoading && !next.hasError && previous?.isLoading == true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hunt created successfully!')),
        );
      }
    });

    final huntState = ref.watch(huntControllerProvider);
    final isLoading = huntState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Create New Hunt')),
      body: isLoading 
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
                    initialValue: _difficulty,
                    decoration: const InputDecoration(labelText: 'Difficulty'),
                    items: ['Easy', 'Normal', 'Hard']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (value) => setState(() => _difficulty = value!),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Show Exact Distance'),
                    subtitle: const Text('If disabled, only proximity clues will be shown (e.g., "You are very close")'),
                    value: _showDistance,
                    onChanged: (value) => setState(() => _showDistance = value),
                  ),
                  const SizedBox(height: 24),
                  HintInputList(
                    controllers: _hintControllers,
                    onAddHint: _addHint,
                    onRemoveHint: _removeHint,
                  ),
                  const SizedBox(height: 24),
                  LocationPickerCard(
                    selectedLocation: _selectedLocation,
                    onPickLocation: _pickLocation,
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
