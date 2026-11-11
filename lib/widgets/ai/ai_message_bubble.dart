import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../config/colors.dart';
import '../../models/api_models.dart';
import '../../models/property.dart';
import '../../screens/property_detail_screen.dart';

class AiMessageBubble extends StatelessWidget {
  final AiChatMessage message;
  final Function(String)? onQuickReplySelected;

  const AiMessageBubble({
    super.key,
    required this.message,
    this.onQuickReplySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: GruhaColors.navy900,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // AI Response Bubble
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gruha AI Avatar
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [GruhaColors.navy950, GruhaColors.navy800],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: GruhaColors.gold400, width: 1),
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome, color: GruhaColors.gold400, size: 14),
                ),
              ),
              const SizedBox(width: 8),

              // AI Text Content with Markdown
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: GruhaColors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: MarkdownBody(
                    data: message.text,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(fontSize: 13, color: GruhaColors.textDark, height: 1.4),
                      h3: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: GruhaColors.navy900,
                      ),
                      strong: const TextStyle(fontWeight: FontWeight.w700, color: GruhaColors.navy900),
                      listBullet: const TextStyle(color: GruhaColors.gold600),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Inline Recommended Properties
          if (message.properties != null && message.properties!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: message.properties!.length,
                  itemBuilder: (ctx, idx) {
                    final p = message.properties![idx];
                    return _AiPropertyCard(property: p);
                  },
                ),
              ),
            ),
          ],

          // Quick Prompt Reply Chips
          if (message.quickReplies != null && message.quickReplies!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: message.quickReplies!.map((reply) {
                  return ActionChip(
                    label: Text(reply, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    backgroundColor: GruhaColors.navy50,
                    side: const BorderSide(color: GruhaColors.borderLight),
                    onPressed: () => onQuickReplySelected?.call(reply),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AiPropertyCard extends StatelessWidget {
  final Property property;

  const _AiPropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    final image = property.images.isNotEmpty
        ? property.images.first
        : 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=600&q=80';

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 10),
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
              builder: (_) => PropertyDetailScreen(property: property),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                image,
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 90, color: GruhaColors.navy50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        property.dealPriceFormatted ?? property.priceFormatted,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: GruhaColors.navy900,
                        ),
                      ),
                      Text(
                        '${property.aiMatch}% Match',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: GruhaColors.verifiedGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${property.locality} • ${property.bedrooms ?? 0} BHK',
                    style: const TextStyle(fontSize: 10, color: GruhaColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

