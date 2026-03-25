import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/character_edit_model.dart';
import '../providers/character_providers.dart';

class EditCharacterScreen extends ConsumerStatefulWidget {
  const EditCharacterScreen({super.key, required this.characterId});

  final int characterId;

  @override
  ConsumerState<EditCharacterScreen> createState() => _EditCharacterScreenState();
}

class _EditCharacterScreenState extends ConsumerState<EditCharacterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _statusController;
  late final TextEditingController _speciesController;
  late final TextEditingController _typeController;
  late final TextEditingController _genderController;
  late final TextEditingController _originController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    final character = ref.read(characterByIdProvider(widget.characterId));
    _nameController = TextEditingController(text: character?.name ?? '');
    _statusController = TextEditingController(text: character?.status ?? '');
    _speciesController = TextEditingController(text: character?.species ?? '');
    _typeController = TextEditingController(text: character?.type ?? '');
    _genderController = TextEditingController(text: character?.gender ?? '');
    _originController = TextEditingController(text: character?.origin.name ?? '');
    _locationController = TextEditingController(text: character?.location.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _speciesController.dispose();
    _typeController.dispose();
    _genderController.dispose();
    _originController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Character')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_nameController, 'Name'),
            _field(_statusController, 'Status'),
            _field(_speciesController, 'Species'),
            _field(_typeController, 'Type'),
            _field(_genderController, 'Gender'),
            _field(_originController, 'Origin name'),
            _field(_locationController, 'Location name'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: const Text('Save locally'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (label == 'Name' && (value == null || value.trim().isEmpty)) {
            return 'Name is required';
          }
          return null;
        },
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final edit = CharacterEditModel(
      id: widget.characterId,
      name: _nameController.text.trim(),
      status: _statusController.text.trim(),
      species: _speciesController.text.trim(),
      type: _typeController.text.trim(),
      gender: _genderController.text.trim(),
      originName: _originController.text.trim(),
      locationName: _locationController.text.trim(),
    );

    await ref.read(characterListProvider.notifier).applyEdit(edit);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Character updated locally')),
    );
    Navigator.pop(context);
  }
}
