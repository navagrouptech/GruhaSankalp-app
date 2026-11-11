import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../providers/app_state.dart';

class CityGrid extends StatelessWidget {
  const CityGrid({super.key});

  static const List<Map<String, String>> cities = [
    {
      'name': 'Hyderabad',
      'desc': 'Tech & Pharma Hub',
      'count': '18,500+ Homes',
      'asset': 'assets/images/cities/hyderabad.jpg',
      'network': 'https://images.unsplash.com/photo-1605649487212-47bdab064df7?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Bengaluru',
      'desc': 'Silicon Valley of India',
      'count': '14,200+ Homes',
      'network': 'https://images.unsplash.com/photo-1596176530529-78163a4f7af2?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Mumbai',
      'desc': 'Financial Capital',
      'count': '11,800+ Homes',
      'network': 'https://images.unsplash.com/photo-1570168007204-dfb528c6958f?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Pune',
      'desc': 'IT & Education Hub',
      'count': '9,400+ Homes',
      'asset': 'assets/images/cities/pune.jpg',
      'network': 'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Chennai',
      'desc': 'Detroit of South Asia',
      'count': '8,900+ Homes',
      'network': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Visakhapatnam',
      'desc': 'City of Destiny',
      'count': '4,600+ Homes',
      'network': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=600&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Top Cities',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: GruhaColors.navy900,
                ),
              ),
              Text(
                'Find verified homes across major Indian real-estate hubs',
                style: TextStyle(fontSize: 11, color: GruhaColors.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: cities.length,
            itemBuilder: (ctx, idx) {
              final c = cities[idx];
              final isSelected = appState.selectedCity == c['name'];

              return Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    appState.setSelectedCity(c['name']!);
                    appState.setBottomNavIndex(1); // switch to Search
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // City Image (Local asset or network fallback)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: c.containsKey('asset')
                            ? Image.asset(
                                c['asset']!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.network(
                                  c['network']!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.network(
                                c['network']!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: GruhaColors.navy900),
                              ),
                      ),

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? GruhaColors.gold400 : Colors.transparent,
                            width: 2,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // City text & count
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              c['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              c['count']!,
                              style: const TextStyle(
                                color: GruhaColors.gold400,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

