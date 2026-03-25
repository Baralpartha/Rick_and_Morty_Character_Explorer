import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/character_model.dart';
import '../providers/character_providers.dart';
import '../widgets/character_card.dart';
import 'character_detail_screen.dart';

class CharacterListScreen extends ConsumerStatefulWidget {
  const CharacterListScreen({super.key});

  @override
  ConsumerState<CharacterListScreen> createState() =>
      _CharacterListScreenState();
}

class _CharacterListScreenState extends ConsumerState<CharacterListScreen> {
  final ScrollController _scrollController = ScrollController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 250) {
      ref.read(characterListProvider.notifier).fetchMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(characterListProvider);
    final notifier = ref.read(characterListProvider.notifier);
    final favoriteIds =
    ref.watch(characterRepositoryProvider).getFavoriteIds().toSet();

    final filtered = state.items.where((item) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;

      return item.name.toLowerCase().contains(q) ||
          item.species.toLowerCase().contains(q) ||
          item.status.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Rick & Morty Explorer',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: notifier.refreshData,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, species, or status',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          if (state.isOffline)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: Row(
                children: const [
                  Icon(Icons.wifi_off_rounded, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Offline mode: showing cached data'),
                  ),
                ],
              ),
            ),
          if (state.isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.error != null && state.items.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Failed to load characters',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.error!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: notifier.refreshData,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (filtered.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No characters found'),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: notifier.refreshData,
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 16),
                    itemCount: filtered.length + (state.isLoadingMore ? 1 : 0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.56,
                    ),
                    itemBuilder: (context, index) {
                      if (index == filtered.length) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final character = filtered[index];
                      return CharacterCard(
                        character: character,
                        isFavorite: favoriteIds.contains(character.id),
                        onFavoriteTap: () => notifier.toggleFavorite(character.id),
                        onTap: () => _openDetails(context, character),
                      );
                    },
                  ),
                ),
              ),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, CharacterModel character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterDetailScreen(characterId: character.id),
      ),
    ).then((_) => setState(() {}));
  }
}