import 'package:flutter/material.dart';
import '../../config/colors.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? _expandedIndex = 0;

  static const List<Map<String, String>> faqs = [
    {
      'q': 'Is GruhaSankalp a safe and secure platform for buying, selling, and renting properties?',
      'a': 'Yes, GruhaSankalp prioritizes safety and security. We verify property details, owner documents, and enable direct buyer-to-owner contact without middleman markup.',
    },
    {
      'q': 'How do I list my property for rent or sale on GruhaSankalp?',
      'a': 'Click "Post Property FREE" in the menu. Follow our guided wizard and use Gruha AI to generate descriptions automatically.',
    },
    {
      'q': 'What is Gruha AI and how does it help me?',
      'a': 'Gruha AI is your 24/7 property assistant. It analyzes property specs, calculates locality match %, recommends listings based on your budget, and automates comparison.',
    },
    {
      'q': 'Can I schedule a physical site visit before making a decision?',
      'a': 'Yes! Simply click "Schedule Visit" on any property details screen, choose your preferred date and time slot, and the owner will confirm your appointment.',
    },
    {
      'q': 'Are there any hidden brokerage fees for buyers and tenants?',
      'a': 'No. GruhaSankalp features zero-brokerage listings direct from owners as well as transparent agent listings.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: GruhaColors.navy900,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Quick answers to common questions about buying, renting, and listing.',
            style: TextStyle(fontSize: 11, color: GruhaColors.textMuted),
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: faqs.length,
            itemBuilder: (ctx, idx) {
              final isExpanded = _expandedIndex == idx;
              final item = faqs[idx];

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: GruhaColors.borderLight),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: isExpanded,
                      onExpansionChanged: (exp) {
                        setState(() {
                          _expandedIndex = exp ? idx : null;
                        });
                      },
                      tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                      title: Text(
                        '${idx + 1}. ${item['q']}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: GruhaColors.navy900,
                        ),
                      ),
                      children: [
                        Text(
                          item['a']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: GruhaColors.textBody,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
