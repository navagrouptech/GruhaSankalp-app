import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../widgets/common/toast_widget.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final List<Map<String, dynamic>> _pendingVerifications = [
    {
      'id': 'v-1',
      'title': '3 BHK Aparna CyberLife Horizon',
      'owner': 'Venkatesh Rao',
      'locality': 'Gachibowli, Hyderabad',
      'docs': 'Title Deed + RERA Certificate',
      'approved': true,
    },
    {
      'id': 'v-2',
      'title': '4 BHK Triplex Prestige Boulevard',
      'owner': 'Suresh Reddy',
      'locality': 'Kokapet, Hyderabad',
      'docs': 'HMDA Layout + Encumbrance Certificate',
      'approved': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Control Center', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.8,
              children: [
                _buildKpiCard('Total Listings', '52,480', Icons.home_work_rounded, GruhaColors.navy900),
                _buildKpiCard('Verified Properties', '48,120', Icons.verified_rounded, GruhaColors.verifiedGreen),
                _buildKpiCard('Total Site Visits', '14,350', Icons.calendar_today_rounded, GruhaColors.blueAccent),
                _buildKpiCard('AI Conversations', '32,800', Icons.auto_awesome, GruhaColors.gold600),
              ],
            ),
            const SizedBox(height: 20),

            // System Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GruhaColors.borderLight),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Infrastructure Status',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: GruhaColors.navy900),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Core Real-Estate API', style: TextStyle(fontSize: 12)),
                      Text('Operational (99.9%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GruhaColors.verifiedGreen)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gruha AI Reasoning Engine', style: TextStyle(fontSize: 12)),
                      Text('Active', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GruhaColors.verifiedGreen)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Database Replication', style: TextStyle(fontSize: 12)),
                      Text('Healthy (Sync OK)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: GruhaColors.verifiedGreen)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Verification Approvals
            const Text(
              'Pending Document Verifications',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: GruhaColors.navy900),
            ),
            const SizedBox(height: 10),

            ..._pendingVerifications.map((item) {
              final isApproved = item['approved'] as bool;
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
                        Expanded(
                          child: Text(
                            item['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isApproved ? GruhaColors.verifiedBg : GruhaColors.alertBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isApproved ? 'Approved' : 'Pending Review',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isApproved ? GruhaColors.verifiedGreen : GruhaColors.alertOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Owner: ${item['owner']} • ${item['locality']}',
                      style: const TextStyle(fontSize: 11, color: GruhaColors.textMuted),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Documents: ${item['docs']}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: GruhaColors.navy800),
                    ),
                    const SizedBox(height: 10),
                    if (!isApproved)
                      ElevatedButton(
                        onPressed: () {
                          setState(() => item['approved'] = true);
                          ToastHelper.showSuccess(context, 'Verified badge granted to listing!');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GruhaColors.verifiedGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Approve Verified Badge', style: TextStyle(fontSize: 11)),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GruhaColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: GruhaColors.navy900)),
                Text(label, style: const TextStyle(fontSize: 10, color: GruhaColors.textMuted), maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
