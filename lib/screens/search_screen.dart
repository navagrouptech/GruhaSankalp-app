import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../config/constants.dart';
import '../models/property.dart';
import '../providers/app_state.dart';
import '../services/property_service.dart';
import '../widgets/property/property_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Property> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _executeSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _executeSearch() async {
    setState(() => _isLoading = true);
    final filter = context.read<AppState>().searchFilter;
    if (_searchController.text.trim().isNotEmpty) {
      filter.locality = _searchController.text.trim();
    }

    try {
      final items = await PropertyService.instance.searchProperties(filter);
      if (mounted) {
        setState(() {
          _results = items;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FilterBottomSheet(
        onApply: () {
          Navigator.pop(ctx);
          _executeSearch();
        },
      ),
    );
  }

  void _showSortSheet() {
    final appState = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Sort Listings By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: GruhaColors.navy900)),
              ),
              const Divider(height: 1),
              _buildSortOption(ctx, appState, 'relevance', 'Relevance (Gruha AI Recommendation)'),
              _buildSortOption(ctx, appState, 'price_asc', 'Price: Low to High'),
              _buildSortOption(ctx, appState, 'price_desc', 'Price: High to Low'),
              _buildSortOption(ctx, appState, 'rating', 'AI Match Percentage'),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(BuildContext ctx, AppState appState, String key, String label) {
    final isSelected = appState.searchFilter.sortBy == key;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          color: isSelected ? GruhaColors.navy900 : GruhaColors.textDark,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: GruhaColors.navy900) : null,
      onTap: () {
        appState.searchFilter.sortBy = key;
        Navigator.pop(ctx);
        _executeSearch();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${appState.activeCategory} Properties',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort Listings',
            onPressed: _showSortSheet,
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Filter Listings',
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                // Locality Search Box
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: GruhaColors.bgLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: GruhaColors.borderLight),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _executeSearch(),
                    decoration: InputDecoration(
                      hintText: 'Search by locality (e.g. Gachibowli, Kokapet)...',
                      hintStyle: const TextStyle(fontSize: 12, color: GruhaColors.textMuted),
                      prefixIcon: const Icon(Icons.search, size: 18, color: GruhaColors.navy700),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18, color: GruhaColors.navy900),
                        onPressed: _executeSearch,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Category Chips (BUY, RENT, PG, COMMERCIAL, PLOTS)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AppConstants.categories.map((cat) {
                      final isSelected = appState.activeCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(cat, style: const TextStyle(fontSize: 11)),
                          selected: isSelected,
                          selectedColor: GruhaColors.navy900,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : GruhaColors.textDark,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          ),
                          onSelected: (val) {
                            if (val) {
                              appState.setActiveCategory(cat);
                              _executeSearch();
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 6),

                // Quick Toggles: Verified & Deals
                Row(
                  children: [
                    FilterChip(
                      avatar: const Icon(Icons.verified, size: 14, color: GruhaColors.verifiedGreen),
                      label: const Text('Verified Only', style: TextStyle(fontSize: 10)),
                      selected: appState.searchFilter.verifiedOnly,
                      selectedColor: GruhaColors.verifiedBg,
                      onSelected: (val) {
                        setState(() => appState.searchFilter.verifiedOnly = val);
                        _executeSearch();
                      },
                    ),
                    const SizedBox(width: 6),
                    FilterChip(
                      avatar: const Icon(Icons.local_fire_department, size: 14, color: GruhaColors.dealRed),
                      label: const Text('Deals Only', style: TextStyle(fontSize: 10)),
                      selected: appState.searchFilter.dealsOnly,
                      selectedColor: GruhaColors.dealBg,
                      onSelected: (val) {
                        setState(() => appState.searchFilter.dealsOnly = val);
                        _executeSearch();
                      },
                    ),
                    const Spacer(),
                    Text(
                      '${_results.length} found',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GruhaColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Search Results List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: GruhaColors.navy900))
                : _results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded, size: 64, color: GruhaColors.textMuted),
                            const SizedBox(height: 12),
                            const Text(
                              'No properties found matching criteria',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try adjusting your locality, budget or category filters.',
                              style: TextStyle(fontSize: 12, color: GruhaColors.textMuted),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () {
                                appState.searchFilter.reset();
                                _searchController.clear();
                                _executeSearch();
                              },
                              child: const Text('Reset All Filters'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _executeSearch,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: _results.length,
                          itemBuilder: (ctx, idx) => PropertyCard(property: _results[idx]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final VoidCallback onApply;

  const _FilterBottomSheet({required this.onApply});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final filter = appState.searchFilter;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter Properties', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: GruhaColors.navy900)),
              TextButton(
                onPressed: () {
                  setState(() => filter.reset());
                },
                child: const Text('Reset', style: TextStyle(color: GruhaColors.dealRed)),
              ),
            ],
          ),
          const Divider(height: 1),
          const SizedBox(height: 14),

          Expanded(
            child: ListView(
              children: [
                // Property Type
                const Text('Property Type', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: AppConstants.propertyTypes.map((type) {
                    final isSel = filter.propertyType == type;
                    return ChoiceChip(
                      label: Text(type, style: const TextStyle(fontSize: 11)),
                      selected: isSel,
                      selectedColor: GruhaColors.navy900,
                      labelStyle: TextStyle(color: isSel ? Colors.white : GruhaColors.textDark),
                      onSelected: (val) {
                        setState(() => filter.propertyType = val ? type : null);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // BHK
                const Text('Bedrooms (BHK)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: AppConstants.bhkOptions.map((bhk) {
                    final isSel = filter.bhk == bhk;
                    return ChoiceChip(
                      label: Text(bhk, style: const TextStyle(fontSize: 11)),
                      selected: isSel,
                      selectedColor: GruhaColors.navy900,
                      labelStyle: TextStyle(color: isSel ? Colors.white : GruhaColors.textDark),
                      onSelected: (val) {
                        setState(() => filter.bhk = val ? bhk : null);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Furnishing
                const Text('Furnishing Status', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: AppConstants.furnishingOptions.map((f) {
                    final isSel = filter.furnishing == f;
                    return ChoiceChip(
                      label: Text(f, style: const TextStyle(fontSize: 11)),
                      selected: isSel,
                      selectedColor: GruhaColors.navy900,
                      labelStyle: TextStyle(color: isSel ? Colors.white : GruhaColors.textDark),
                      onSelected: (val) {
                        setState(() => filter.furnishing = val ? f : null);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // City
                const Text('City', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: AppConstants.popularCities.map((city) {
                    final isSel = filter.city == city;
                    return ChoiceChip(
                      label: Text(city == 'All' ? 'All India' : city, style: const TextStyle(fontSize: 11)),
                      selected: isSel,
                      selectedColor: GruhaColors.navy900,
                      labelStyle: TextStyle(color: isSel ? Colors.white : GruhaColors.textDark),
                      onSelected: (val) {
                        setState(() => filter.city = val ? city : 'All');
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onApply,
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
