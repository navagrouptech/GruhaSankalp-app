import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../providers/app_state.dart';

class HeroSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onFilterTap;

  const HeroSearchBar({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: GruhaColors.borderLight)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trust Announcement Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: GruhaColors.navy50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GruhaColors.borderLight),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: GruhaColors.verifiedGreen),
                SizedBox(width: 6),
                Text(
                  'AI-Assisted Property Discovery & Direct Owner Deals',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: GruhaColors.navy900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Main Headline
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: GruhaColors.navy950,
                letterSpacing: -0.5,
              ),
              children: [
                TextSpan(text: "Find a Place You'll Love to Call "),
                TextSpan(
                  text: 'Home',
                  style: TextStyle(color: GruhaColors.gold600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "India's trusted real-estate ecosystem with zero brokerage.",
            style: TextStyle(fontSize: 12, color: GruhaColors.textMuted),
          ),
          const SizedBox(height: 14),

          // Category Tabs: BUY | RENT | PG | COMMERCIAL | PLOTS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AppConstants.categories.map((cat) {
                final isSelected = appState.activeCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: GruhaColors.navy900,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : GruhaColors.textDark,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? GruhaColors.navy900 : GruhaColors.borderLight,
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        appState.setActiveCategory(cat);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Search Field & Filter Trigger
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: GruhaColors.bgLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: GruhaColors.borderLight),
                  ),
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (_) => onSearch(),
                    decoration: InputDecoration(
                      hintText: 'Search locality, project, or landmark...',
                      hintStyle: const TextStyle(fontSize: 13, color: GruhaColors.textMuted),
                      prefixIcon: const Icon(Icons.search, size: 20, color: GruhaColors.navy700),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                searchController.clear();
                                onSearch();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Filter Icon Button
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: GruhaColors.navy900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                  onPressed: onFilterTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Trust Badges Row
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _TrustBadge(
                  icon: Icons.check_circle_rounded,
                  iconColor: GruhaColors.blueAccent,
                  label: '50,000+ Listings',
                ),
                SizedBox(width: 8),
                _TrustBadge(
                  icon: Icons.bolt_rounded,
                  iconColor: GruhaColors.gold600,
                  label: '0% Brokerage',
                ),
                SizedBox(width: 8),
                _TrustBadge(
                  icon: Icons.verified_rounded,
                  iconColor: GruhaColors.verifiedGreen,
                  label: 'RERA Approved',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _TrustBadge({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: GruhaColors.bgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GruhaColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: GruhaColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

