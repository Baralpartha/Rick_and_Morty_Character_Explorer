import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/character_providers.dart';
import '../widgets/status_chip.dart';
import 'edit_character_screen.dart';

class CharacterDetailScreen extends ConsumerWidget {
  const CharacterDetailScreen({super.key, required this.characterId});

  final int characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterByIdProvider(characterId));
    final favoriteIds = ref.watch(characterRepositoryProvider).getFavoriteIds().toSet();
    final notifier = ref.read(characterListProvider.notifier);

    if (character == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Character not found in cache')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        actions: [
          IconButton(
            onPressed: () => notifier.toggleFavorite(character.id),
            icon: Icon(
              favoriteIds.contains(character.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCharacterScreen(characterId: character.id),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: Image.network(
                character.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  StatusChip(status: character.status),
                  const SizedBox(height: 20),
                  _InfoRow(label: 'Species', value: character.species),
                  _InfoRow(label: 'Type', value: character.type.isEmpty ? 'Unknown' : character.type),
                  _InfoRow(label: 'Gender', value: character.gender),
                  _InfoRow(label: 'Origin', value: character.origin.name),
                  _InfoRow(label: 'Location', value: character.location.name),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => notifier.resetEdit(character.id),
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset to API data'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? 'Unknown' : value)),
        ],
      ),
    );
  }
}
