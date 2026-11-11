import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../models/property.dart';
import '../providers/app_state.dart';
import 'property_detail_screen.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final properties = appState.compareList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Properties', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          if (properties.isNotEmpty)
            TextButton(
              onPressed: () => appState.clearCompare(),
              child: const Text('Clear All', style: TextStyle(color: GruhaColors.dealRed, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: properties.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.compare_arrows_rounded, size: 64, color: GruhaColors.textMuted),
                  const SizedBox(height: 16),
                  const Text(
                    'No properties added to compare',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: GruhaColors.navy900),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tap the compare icon on any property card to compare up to 3 listings.',
                    style: TextStyle(fontSize: 12, color: GruhaColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => appState.setBottomNavIndex(1),
                    child: const Text('Browse Properties'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card Row with Images
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 120,
                          child: Text(
                            'Property Overview',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: GruhaColors.navy900),
                          ),
                        ),
                        ...properties.map((p) => _buildPropertyHeader(context, appState, p)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Comparison Spec Rows
                    _buildCompareRow('Price', properties.map((p) => p.dealPriceFormatted ?? p.priceFormatted).toList(), isBold: true),
                    _buildCompareRow('Price / Sq.Ft', properties.map((p) => p.pricePerSqFt != null ? '₹${p.pricePerSqFt}/sq.ft' : 'N/A').toList()),
                    _buildCompareRow('AI Match Score', properties.map((p) => '${p.aiMatch}% Match').toList(), highlightColor: GruhaColors.gold600),
                    _buildCompareRow('Locality', properties.map((p) => p.locality).toList()),
                    _buildCompareRow('Bedrooms', properties.map((p) => '${p.bedrooms ?? 0} BHK').toList()),
                    _buildCompareRow('Bathrooms', properties.map((p) => '${p.bathrooms ?? 0} Baths').toList()),
                    _buildCompareRow('Super Area', properties.map((p) => '${p.area} sq.ft').toList()),
                    _buildCompareRow('Furnishing', properties.map((p) => p.furnishing ?? 'Unspecified').toList()),
                    _buildCompareRow('Facing', properties.map((p) => p.facing ?? 'East').toList()),
                    _buildCompareRow('Possession', properties.map((p) => p.possessionStatus ?? 'Ready to Move').toList()),
                    _buildCompareRow('RERA Status', properties.map((p) => p.reraId != null ? 'RERA Approved' : 'Direct Owner').toList(), highlightColor: GruhaColors.verifiedGreen),
                    _buildCompareRow('Brokerage', properties.map((_) => '0% (Zero)').toList(), highlightColor: GruhaColors.verifiedGreen),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPropertyHeader(BuildContext context, AppState appState, Property property) {
    final image = property.images.isNotEmpty
        ? property.images.first
        : 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=600&q=80';

    return Container(
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  image,
                  height: 110,
                  width: 170,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 110, color: GruhaColors.navy50),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close, size: 16, color: GruhaColors.dealRed),
                    onPressed: () => appState.toggleCompare(property),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            property.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PropertyDetailScreen(property: property)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GruhaColors.navy900,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
            ),
            child: const Text('View Full Details', style: TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareRow(String label, List<String> values, {bool isBold = false, Color? highlightColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GruhaColors.textMuted),
            ),
          ),
          ...values.map((v) {
            return Container(
              width: 170,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: GruhaColors.borderLight),
              ),
              child: Text(
                v,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                  color: highlightColor ?? GruhaColors.textDark,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

