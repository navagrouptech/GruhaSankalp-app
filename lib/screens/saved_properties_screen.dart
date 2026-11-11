import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../providers/app_state.dart';
import '../services/mock_data.dart';
import '../widgets/property/property_card.dart';
import 'compare_screen.dart';

class SavedPropertiesScreen extends StatelessWidget {
  const SavedPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final savedIds = appState.savedPropertyIds;

    // Filter properties matching saved IDs
    final savedProps = MockData.defaultProperties
        .where((p) => savedIds.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Properties (${savedProps.length})',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          if (appState.compareList.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.compare_arrows_rounded, size: 18),
              label: Text('Compare (${appState.compareList.length})'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CompareScreen()),
                );
              },
            ),
        ],
      ),
      body: savedProps.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border_rounded, size: 64, color: GruhaColors.textMuted),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved properties yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: GruhaColors.navy900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tap the heart icon on any property to save it to your wishlist.',
                    style: TextStyle(fontSize: 12, color: GruhaColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => appState.setBottomNavIndex(1),
                    child: const Text('Explore Properties'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: savedProps.length,
              itemBuilder: (ctx, idx) => PropertyCard(property: savedProps[idx]),
            ),
    );
  }
}
