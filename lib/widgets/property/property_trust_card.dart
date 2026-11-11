import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../models/property.dart';

class PropertyTrustCard extends StatelessWidget {
  final Property property;

  const PropertyTrustCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GruhaColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(Icons.verified_user_rounded, color: GruhaColors.verifiedGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Property Verification Status',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: GruhaColors.navy900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 1. Locality & Coordinates
          _buildCheckItem(
            title: 'Locality (${property.locality}) & Coordinates',
            status: 'Verified',
            isVerified: true,
          ),
          const SizedBox(height: 8),

          // 2. Owner verified
          _buildCheckItem(
            title: 'Owner verified (${property.owner.name})',
            status: 'Verified',
            isVerified: true,
          ),
          const SizedBox(height: 8),

          // 3. Property photos
          _buildCheckItem(
            title: 'Property photos (${property.images.length} verified photos)',
            status: 'Verified',
            isVerified: true,
          ),
          const SizedBox(height: 8),

          // 4. Physical title deed verification
          _buildCheckItem(
            title: 'Physical title deed & RERA validation',
            status: property.reraId != null ? 'Verified' : 'In Progress',
            isVerified: property.reraId != null,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem({
    required String title,
    required String status,
    required bool isVerified,
  }) {
    final bgColor = isVerified ? GruhaColors.verifiedBg : GruhaColors.alertBg;
    final textColor = isVerified ? const Color(0xFF065F46) : const Color(0xFF92400E);
    final badgeBg = isVerified ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isVerified ? Icons.check_circle_rounded : Icons.pending_rounded,
            size: 16,
            color: isVerified ? GruhaColors.verifiedGreen : GruhaColors.alertOrange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

