import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../providers/app_state.dart';
import '../widgets/ai/ai_message_bubble.dart';

class AiAssistantScreen extends StatefulWidget {
  final String? initialPrompt;

  const AiAssistantScreen({super.key, this.initialPrompt});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  final List<String> _suggestedPrompts = [
    '3 BHK in Gachibowli under 2 Cr',
    'Luxury Villas in Kokapet with pool',
    'Rental flats near Mindspace IT Park',
    'Show exclusive verified deals',
    'HMDA approved plots in Shankarpally',
    'Best PGs with zero deposit',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendQuery(widget.initialPrompt!);
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendQuery(String query) {
    if (query.trim().isEmpty) return;
    final state = context.read<AppState>();
    state.sendAiMessage(query.trim());
    _inputController.clear();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _simulateVoiceInput() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎙️ Listening... (Say your property requirements)'),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _inputController.text = 'Find 3 BHK flats in Gachibowli under 2 Cr with swimming pool';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final messages = appState.aiMessages;

    return Scaffold(
      backgroundColor: GruhaColors.bgLight,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: GruhaColors.navy950,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: GruhaColors.gold400, size: 16),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gruha AI Assistant',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                ),
                Text(
                  'Online 24/7 • Smart Real-Estate Advisor',
                  style: TextStyle(fontSize: 10, color: GruhaColors.verifiedGreen, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Suggested Prompt Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _suggestedPrompts.length,
                itemBuilder: (ctx, idx) {
                  final prompt = _suggestedPrompts[idx];
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      label: Text(prompt, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      backgroundColor: GruhaColors.navy50,
                      side: const BorderSide(color: GruhaColors.borderLight),
                      onPressed: () => _sendQuery(prompt),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),

          // Message Thread
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (ctx, idx) {
                return AiMessageBubble(
                  message: messages[idx],
                  onQuickReplySelected: (reply) => _sendQuery(reply),
                );
              },
            ),
          ),

          // Typing indicator
          if (appState.isAiTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: GruhaColors.navy950,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.auto_awesome, color: GruhaColors.gold400, size: 12),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Gruha AI is analyzing verified properties...',
                    style: TextStyle(fontSize: 12, color: GruhaColors.textMuted, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

          // Bottom Input Bar
          Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).viewInsets.bottom + 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: GruhaColors.borderLight)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Voice Mic Icon Button
                  IconButton(
                    icon: const Icon(Icons.mic, color: GruhaColors.navy900),
                    tooltip: 'Voice Search',
                    onPressed: _simulateVoiceInput,
                  ),

                  // Text Field
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      onSubmitted: (val) => _sendQuery(val),
                      decoration: const InputDecoration(
                        hintText: 'Ask Gruha AI anything about properties...',
                        hintStyle: TextStyle(fontSize: 13, color: GruhaColors.textMuted),
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Send Button
                  Container(
                    decoration: const BoxDecoration(
                      color: GruhaColors.navy900,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: () => _sendQuery(_inputController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

