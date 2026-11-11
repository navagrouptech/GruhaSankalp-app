import 'package:flutter/material.dart';
import '../../config/colors.dart';

class AgentDashboardScreen extends StatefulWidget {
  const AgentDashboardScreen({super.key});

  @override
  State<AgentDashboardScreen> createState() => _AgentDashboardScreenState();
}

class _AgentDashboardScreenState extends State<AgentDashboardScreen> {
  String _selectedStage = 'All';

  final List<String> _stages = ['All', 'New Lead', 'Visit Scheduled', 'Negotiating', 'Closed'];

  final List<Map<String, String>> _leads = [
    {
      'id': 'lead-1',
      'name': 'Rahul Verma',
      'property': '3 BHK High-Rise in Gachibowli',
      'budget': '₹1.85 Cr',
      'stage': 'Visit Scheduled',
      'date': 'Today, 2:30 PM',
      'phone': '+91 98490 22334',
    },
    {
      'id': 'lead-2',
      'name': 'Pooja Iyer',
      'property': '4 BHK Villa in Kokapet',
      'budget': '₹3.60 Cr',
      'stage': 'Negotiating',
      'date': 'Yesterday',
      'phone': '+91 99887 11223',
    },
    {
      'id': 'lead-3',
      'name': 'Amit Saxena',
      'property': 'Commercial IT Floor in Hitec City',
      'budget': '₹2.40 Lakhs/mo',
      'stage': 'New Lead',
      'date': '2 days ago',
      'phone': '+91 91234 44556',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedStage == 'All'
        ? _leads
        : _leads.where((l) => l['stage'] == _selectedStage).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent CRM & Pipeline', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: Column(
        children: [
          // Pipeline Stages Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _stages.length,
                itemBuilder: (ctx, idx) {
                  final stage = _stages[idx];
                  final isSel = _selectedStage == stage;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(stage, style: const TextStyle(fontSize: 11)),
                      selected: isSel,
                      selectedColor: GruhaColors.navy900,
                      labelStyle: TextStyle(color: isSel ? Colors.white : GruhaColors.textDark, fontWeight: FontWeight.bold),
                      onSelected: (val) {
                        if (val) setState(() => _selectedStage = stage);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (ctx, idx) {
                final lead = filtered[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: GruhaColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lead['name']!,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: GruhaColors.navy900),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: GruhaColors.gold50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              lead['stage']!,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: GruhaColors.gold600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Interested in: ${lead['property']}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: GruhaColors.textDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Budget: ${lead['budget']} • Contact: ${lead['phone']}',
                        style: const TextStyle(fontSize: 11, color: GruhaColors.textMuted),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

