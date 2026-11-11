import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../models/property.dart';
import '../providers/app_state.dart';
import '../services/property_service.dart';
import '../widgets/home/city_grid.dart';
import '../widgets/home/deals_carousel.dart';
import '../widgets/home/faq_section.dart';
import '../widgets/home/hero_search_bar.dart';
import '../widgets/property/property_card.dart';
import 'ai_assistant_screen.dart';
import 'post_property_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  List<Property> _featuredProperties = [];
  List<Property> _deals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final selectedCity = context.read<AppState>().selectedCity;

    try {
      final featured = await PropertyService.instance.getFeaturedProperties(
        limit: 6,
        city: selectedCity,
      );
      final deals = await PropertyService.instance.getDeals(limit: 6);

      if (mounted) {
        setState(() {
          _featuredProperties = featured;
          _deals = deals;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final state = context.read<AppState>();
      state.searchFilter.locality = query;
      state.setBottomNavIndex(1); // Switch to search tab
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: RefreshIndicator(
        color: GruhaColors.navy900,
        onRefresh: _loadData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HERO SEARCH & CATEGORIES
              HeroSearchBar(
                searchController: _searchController,
                onSearch: _onSearch,
                onFilterTap: () {
                  appState.setBottomNavIndex(1);
                },
              ),
              const SizedBox(height: 16),

              // 2. EXCLUSIVE PROPERTY DEALS
              if (_deals.isNotEmpty) ...[
                DealsCarousel(deals: _deals),
                const SizedBox(height: 20),
              ],

              // 3. EXPLORE CITIES
              const CityGrid(),
              const SizedBox(height: 24),

              // 4. GRUHA AI BANNER CTA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [GruhaColors.navy950, GruhaColors.navy900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: GruhaColors.gold400.withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: GruhaColors.navy900.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome, color: GruhaColors.gold400, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Confused where to buy or rent?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Ask Gruha AI for instant match %, price trends, and zero-brokerage listings.',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AiAssistantScreen()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: GruhaColors.gold500,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Chat with Gruha AI',
                                      style: TextStyle(
                                        color: GruhaColors.navy950,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 11,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_rounded, size: 12, color: GruhaColors.navy950),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. FEATURED PROPERTIES HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Featured Properties in ${appState.selectedCity == "All" ? "India" : appState.selectedCity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: GruhaColors.navy900,
                          ),
                        ),
                        const Text(
                          'Handpicked verified homes direct from owners',
                          style: TextStyle(fontSize: 11, color: GruhaColors.textMuted),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => appState.setBottomNavIndex(1),
                      child: const Text('See All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),

              // FEATURED PROPERTIES LIST
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(color: GruhaColors.navy900),
                  ),
                )
              else
                ..._featuredProperties.map((p) => PropertyCard(property: p)),

              const SizedBox(height: 16),

              // 6. POST PROPERTY BANNER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: GruhaColors.gold50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: GruhaColors.gold200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add_home_work_rounded, color: GruhaColors.gold600, size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Are you an Owner, Builder or Agent?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: GruhaColors.navy950,
                              ),
                            ),
                            const Text(
                              'Post your property for FREE with AI description generator.',
                              style: TextStyle(fontSize: 11, color: GruhaColors.textDark),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const PostPropertyScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: GruhaColors.navy900,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                minimumSize: Size.zero,
                              ),
                              child: const Text(
                                'Post Property FREE',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 7. FAQ ACCORDION
              const FaqSection(),
              const SizedBox(height: 80), // spacing for bottom bar
            ],
          ),
        ),
      ),
    );
  }
}

