import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../models/property.dart';
import '../../providers/app_state.dart';
import '../../screens/property_detail_screen.dart';
import '../common/toast_widget.dart';

class PropertyCard extends StatefulWidget {
  final Property property;
  final VoidCallback? onTap;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isSaved = appState.isSaved(widget.property.id);
    final inCompare = appState.isInCompare(widget.property.id);
    final images = widget.property.images.isNotEmpty
        ? widget.property.images
        : [
            'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=1200&q=80'
          ];

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: GruhaColors.borderLight, width: 1),
      ),
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: widget.onTap ??
            () {
              appState.addRecentlyViewed(widget.property.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PropertyDetailScreen(property: widget.property),
                ),
              );
            },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- IMAGE CAROUSEL WITH OVERLAY BADGES ---
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (idx) {
                      setState(() => _currentImageIndex = idx);
                    },
                    itemBuilder: (ctx, idx) {
                      return Image.network(
                        images[idx],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: GruhaColors.navy50,
                          child: const Center(
                            child: Icon(Icons.home, size: 48, color: GruhaColors.navy600),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Top Gradient for badge legibility
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Left Badges: Deal Tag & Verified
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      if (widget.property.isDeal && widget.property.dealTag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: GruhaColors.dealRed,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department, color: Colors.white, size: 12),
                              const SizedBox(width: 3),
                              Text(
                                widget.property.dealTag!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (widget.property.verified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: GruhaColors.verifiedGreen,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, color: Colors.white, size: 12),
                              SizedBox(width: 3),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Right Badges: Save Heart & Compare
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    children: [
                      // Compare Toggle Button
                      GestureDetector(
                        onTap: () {
                          final added = appState.toggleCompare(widget.property);
                          if (added) {
                            ToastHelper.showSuccess(
                              context,
                              'Added to comparison (${appState.compareList.length}/3)',
                            );
                          } else if (inCompare) {
                            ToastHelper.showInfo(context, 'Removed from comparison');
                          } else {
                            ToastHelper.showError(
                              context,
                              'You can compare up to 3 properties at a time.',
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: inCompare ? GruhaColors.gold500 : Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.compare_arrows_rounded,
                            size: 18,
                            color: inCompare ? Colors.white : GruhaColors.navy900,
                          ),
                        ),
                      ),

                      // Heart Save Button
                      GestureDetector(
                        onTap: () {
                          appState.toggleSaveProperty(widget.property.id);
                          if (!isSaved) {
                            ToastHelper.showSuccess(context, 'Property saved to favorites!');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isSaved ? GruhaColors.dealRed : GruhaColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // AI Match Percentage Badge (Bottom-Right of Image)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: GruhaColors.navy950.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GruhaColors.gold400, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome, color: GruhaColors.gold400, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.property.aiMatch}% Match',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Image Carousel Indicator Dots
                if (images.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Row(
                      children: List.generate(images.length, (idx) {
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          width: _currentImageIndex == idx ? 16 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentImageIndex == idx ? Colors.white : Colors.white54,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),

            // --- PROPERTY DETAILS CONTENT ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Row & Savings
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.property.dealPriceFormatted ?? widget.property.priceFormatted,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: GruhaColors.navy900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (widget.property.dealPriceFormatted != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          widget.property.priceFormatted,
                          style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: GruhaColors.textMuted,
                          ),
                        ),
                      ],
                      if (widget.property.dealSavings != null) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: GruhaColors.verifiedBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.property.dealSavings!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: GruhaColors.verifiedGreen,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    widget.property.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: GruhaColors.textDark,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Locality & City
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: GruhaColors.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.property.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: GruhaColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Specifications Row: BHK, Baths, Sq.Ft, Furnishing
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: GruhaColors.navy50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (widget.property.bedrooms != null)
                          _buildSpecItem(Icons.bed_outlined, '${widget.property.bedrooms} BHK'),
                        if (widget.property.bathrooms != null)
                          _buildSpecItem(Icons.bathtub_outlined, '${widget.property.bathrooms} Baths'),
                        _buildSpecItem(Icons.square_foot_outlined, '${widget.property.area} ${widget.property.areaUnit}'),
                        if (widget.property.furnishing != null)
                          _buildSpecItem(Icons.chair_outlined, widget.property.furnishing!.split(' ').first),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Owner / Verified Contact & Action Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Owner info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: GruhaColors.navy800,
                            child: Text(
                              widget.property.owner.name.substring(0, 1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.property.owner.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: GruhaColors.textDark,
                                ),
                              ),
                              Text(
                                '${widget.property.owner.type} • Zero Brokerage',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: GruhaColors.verifiedGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // "View Details" Pill Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: GruhaColors.navy900,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: GruhaColors.navy700),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: GruhaColors.navy900,
          ),
        ),
      ],
    );
  }
}

