import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../models/property.dart';
import '../providers/app_state.dart';
import '../services/property_service.dart';
import '../widgets/common/toast_widget.dart';
import '../widgets/forms/contact_owner_sheet.dart';
import '../widgets/forms/schedule_visit_sheet.dart';
import '../widgets/property/ai_analysis_card.dart';
import '../widgets/property/property_trust_card.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _activeImageIndex = 0;
  List<Property> _similarProperties = [];

  @override
  void initState() {
    super.initState();
    _loadSimilar();
  }

  Future<void> _loadSimilar() async {
    final list = await PropertyService.instance.getSimilarProperties(widget.property.id);
    if (mounted) setState(() => _similarProperties = list);
  }

  void _openScheduleVisit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ScheduleVisitSheet(property: widget.property),
    );
  }

  void _openContactOwner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ContactOwnerSheet(property: widget.property),
    );
  }

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

    return Scaffold(
      backgroundColor: GruhaColors.bgLight,
      body: CustomScrollView(
        slivers: [
          // Silver App Bar with Photo Swiper
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: GruhaColors.navy900,
            leading: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              // Compare Button
              CircleAvatar(
                backgroundColor: inCompare ? GruhaColors.gold500 : Colors.black.withValues(alpha: 0.5),
                child: IconButton(
                  icon: const Icon(Icons.compare_arrows_rounded, color: Colors.white, size: 20),
                  onPressed: () {
                    final added = appState.toggleCompare(widget.property);
                    if (added) {
                      ToastHelper.showSuccess(context, 'Added to compare list!');
                    } else if (inCompare) {
                      ToastHelper.showInfo(context, 'Removed from compare');
                    } else {
                      ToastHelper.showError(context, 'Comparison limit is 3 properties.');
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),

              // Save Heart Button
              CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                child: IconButton(
                  icon: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: isSaved ? GruhaColors.dealRed : Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    appState.toggleSaveProperty(widget.property.id);
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (idx) => setState(() => _activeImageIndex = idx),
                    itemBuilder: (ctx, idx) {
                      return Image.network(
                        images[idx],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: GruhaColors.navy900),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 12,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${_activeImageIndex + 1} / ${images.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price & Deal Banner
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.property.dealPriceFormatted ?? widget.property.priceFormatted,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: GruhaColors.navy900,
                        ),
                      ),
                      if (widget.property.dealPriceFormatted != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          widget.property.priceFormatted,
                          style: const TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            color: GruhaColors.textMuted,
                          ),
                        ),
                      ],
                      if (widget.property.pricePerSqFt != null) ...[
                        const Spacer(),
                        Text(
                          '₹${widget.property.pricePerSqFt}/sq.ft',
                          style: const TextStyle(fontSize: 12, color: GruhaColors.textMuted, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    widget.property.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: GruhaColors.textDark,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Address
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: GruhaColors.navy700),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.property.address,
                          style: const TextStyle(fontSize: 13, color: GruhaColors.textMuted, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Specifications Grid
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GruhaColors.borderLight),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (widget.property.bedrooms != null)
                              _buildSpecItem('Bedrooms', '${widget.property.bedrooms} BHK', Icons.bed_outlined),
                            if (widget.property.bathrooms != null)
                              _buildSpecItem('Bathrooms', '${widget.property.bathrooms} Baths', Icons.bathtub_outlined),
                            _buildSpecItem('Super Area', '${widget.property.area} sq.ft', Icons.square_foot_outlined),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSpecItem('Furnishing', widget.property.furnishing ?? 'Semi Furnished', Icons.chair_outlined),
                            _buildSpecItem('Facing', widget.property.facing ?? 'East', Icons.explore_outlined),
                            _buildSpecItem('Possession', widget.property.possessionStatus ?? 'Ready to Move', Icons.key_outlined),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // GRUHA AI ANALYSIS CARD
                  GruhaAIAnalysisCard(property: widget.property),
                  const SizedBox(height: 16),

                  // PROPERTY TRUST & VERIFICATION CARD
                  PropertyTrustCard(property: widget.property),
                  const SizedBox(height: 16),

                  // Description
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GruhaColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Overview & Description', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: GruhaColors.navy900)),
                        const SizedBox(height: 8),
                        Text(
                          widget.property.description,
                          style: const TextStyle(fontSize: 13, color: GruhaColors.textBody, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Amenities Chips
                  if (widget.property.amenities.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: GruhaColors.borderLight),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Lifestyle Amenities', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: GruhaColors.navy900)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.property.amenities.map((amenity) {
                              return Chip(
                                avatar: const Icon(Icons.check, size: 14, color: GruhaColors.navy900),
                                label: Text(amenity, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                backgroundColor: GruhaColors.navy50,
                                side: const BorderSide(color: GruhaColors.borderLight),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Owner Contact Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: GruhaColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: GruhaColors.navy900,
                          child: Text(
                            widget.property.owner.name.substring(0, 1),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.property.owner.name,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: GruhaColors.navy900),
                              ),
                              Text(
                                '${widget.property.owner.type} • Direct Zero Brokerage',
                                style: const TextStyle(fontSize: 11, color: GruhaColors.verifiedGreen, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Similar Properties
                  if (_similarProperties.isNotEmpty) ...[
                    const Text(
                      'Similar Verified Properties',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: GruhaColors.navy900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _similarProperties.length,
                        itemBuilder: (ctx, idx) {
                          final sim = _similarProperties[idx];
                          return Container(
                            width: 220,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: GruhaColors.borderLight),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PropertyDetailScreen(property: sim),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: Image.network(
                                      sim.images.isNotEmpty ? sim.images.first : '',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(height: 100, color: GruhaColors.navy50),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sim.priceFormatted,
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: GruhaColors.navy900),
                                        ),
                                        Text(
                                          sim.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          '${sim.locality} • ${sim.bedrooms ?? 0} BHK',
                                          style: const TextStyle(fontSize: 10, color: GruhaColors.textMuted),
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
                  const SizedBox(height: 80), // for bottom booking bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed Bottom Action Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Contact Owner'),
                  onPressed: _openContactOwner,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_month_outlined, size: 18),
                  label: const Text('Schedule Visit'),
                  onPressed: _openScheduleVisit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: GruhaColors.navy700),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: GruhaColors.navy900)),
        Text(label, style: const TextStyle(fontSize: 10, color: GruhaColors.textMuted)),
      ],
    );
  }
}
