import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../services/mock_data.dart';
import '../post_property_screen.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listings = MockData.defaultProperties.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Dashboard', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Property',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PostPropertyScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                _buildStat('Active Listings', '3', Icons.home_work_outlined),
                const SizedBox(width: 10),
                _buildStat('Buyer Enquiries', '18', Icons.people_outline),
                const SizedBox(width: 10),
                _buildStat('Site Visits', '7', Icons.calendar_today_outlined),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Listed Properties',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: GruhaColors.navy900),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PostPropertyScreen()));
                  },
                  child: const Text('+ Post New Property'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...listings.map((prop) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: GruhaColors.borderLight),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        prop.images.isNotEmpty ? prop.images.first : '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: GruhaColors.navy50),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prop.priceFormatted,
                                style: const TextStyle(fontWeight: FontWeight.w900, color: GruhaColors.navy900, fontSize: 14),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: GruhaColors.verifiedBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Live on App',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: GruhaColors.verifiedGreen),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            prop.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${prop.locality} • 142 Views • 6 Inquiries',
                            style: const TextStyle(fontSize: 10, color: GruhaColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: GruhaColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: GruhaColors.navy700, size: 20),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: GruhaColors.navy900)),
            Text(label, style: const TextStyle(fontSize: 10, color: GruhaColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

