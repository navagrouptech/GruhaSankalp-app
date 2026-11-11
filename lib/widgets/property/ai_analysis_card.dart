import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../models/property.dart';

class GruhaAIAnalysisCard extends StatelessWidget {
  final Property property;

  const GruhaAIAnalysisCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final reasons = property.aiReasons.isNotEmpty
        ? property.aiReasons
        : [
            'Direct Owner Listing — Zero Brokerage',
            'Prime high-growth locality with excellent connectivity',
            '100% Vastu-compliant layout with natural light',
            'Verified clear title deed with approved municipal documents',
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GruhaColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: GruhaColors.navy900.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with AI Icon and Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: GruhaColors.navy950,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'AI',
                      style: TextStyle(
                        color: GruhaColors.gold400,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gruha AI Property Analysis',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: GruhaColors.navy900,
                        ),
                      ),
                      Text(
                        'Intelligent valuation & locality metrics',
                        style: TextStyle(fontSize: 11, color: GruhaColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),

              // Match Score Pill
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${property.aiMatch}%',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: GruhaColors.navy900,
                    ),
                  ),
                  const Text(
                    'MATCH SCORE',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: GruhaColors.gold600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Key Highlights
          const Text(
            'KEY PROPERTY HIGHLIGHTS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: GruhaColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          ...reasons.map((reason) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.check_circle, size: 14, color: GruhaColors.verifiedGreen),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reason,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: GruhaColors.textDark,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

