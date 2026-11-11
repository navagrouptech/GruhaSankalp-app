import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../providers/app_state.dart';
import '../auth/login_screen.dart';
import '../compare_screen.dart';
import '../post_property_screen.dart';
import 'admin_dashboard_screen.dart';
import 'agent_dashboard_screen.dart';
import 'seller_dashboard_screen.dart';

class BuyerDashboardScreen extends StatelessWidget {
  const BuyerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.userProfile;
    final visits = appState.siteVisits;
    final enquiries = appState.enquiries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account & Dashboard', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          if (appState.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Sign Out',
              onPressed: () => appState.logout(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // USER PROFILE HEADER CARD
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: GruhaColors.navy900,
                    child: Text(
                      user != null ? user.fullName.substring(0, 1) : 'G',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null ? user.fullName : 'Guest User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: GruhaColors.navy950,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user != null ? user.email : 'Sign in to sync your saved listings & visits',
                          style: const TextStyle(fontSize: 12, color: GruhaColors.textMuted),
                        ),
                        const SizedBox(height: 8),
                        if (user != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: GruhaColors.navy50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Role: ${user.role} • Verified User',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: GruhaColors.navy900),
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              minimumSize: Size.zero,
                            ),
                            child: const Text('Sign In / Register', style: TextStyle(fontSize: 11)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // QUICK METRICS ROW
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildMetricTile('Saved', '${appState.savedPropertyIds.length}', Icons.favorite_rounded, GruhaColors.dealRed),
                  const SizedBox(width: 10),
                  _buildMetricTile('Visits', '${visits.length}', Icons.calendar_today_rounded, GruhaColors.blueAccent),
                  const SizedBox(width: 10),
                  _buildMetricTile('Enquiries', '${enquiries.length}', Icons.mail_rounded, GruhaColors.gold600),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // DASHBOARDS SWITCHER (Buyer, Seller, Agent, Admin)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Role Portals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: GruhaColors.navy900)),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: GruhaColors.borderLight),
                ),
                child: Column(
                  children: [
                    _buildNavTile(
                      title: 'Post Property FREE',
                      subtitle: 'List your home or plot with Gruha AI',
                      icon: Icons.add_home_work_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PostPropertyScreen())),
                    ),
                    const Divider(height: 1),
                    _buildNavTile(
                      title: 'Seller Dashboard',
                      subtitle: 'Manage listings, leads, and price updates',
                      icon: Icons.storefront_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerDashboardScreen())),
                    ),
                    const Divider(height: 1),
                    _buildNavTile(
                      title: 'Agent CRM Portal',
                      subtitle: 'Client inquiries & lead pipeline tracking',
                      icon: Icons.support_agent_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgentDashboardScreen())),
                    ),
                    const Divider(height: 1),
                    _buildNavTile(
                      title: 'Admin Control Center',
                      subtitle: 'Platform analytics, verified badge approvals',
                      icon: Icons.admin_panel_settings_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen())),
                    ),
                    const Divider(height: 1),
                    _buildNavTile(
                      title: 'Compare Properties',
                      subtitle: 'Review up to 3 selected homes side by side',
                      icon: Icons.compare_arrows_rounded,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompareScreen())),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // SCHEDULED SITE VISITS LIST
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Scheduled Site Visits', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: GruhaColors.navy900)),
                  Text('${visits.length} scheduled', style: const TextStyle(fontSize: 11, color: GruhaColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            if (visits.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: GruhaColors.borderLight),
                  ),
                  child: const Center(
                    child: Text('No site visits booked yet. Browse homes to schedule a free visit!'),
                  ),
                ),
              )
            else
              ...visits.map((visit) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: GruhaColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: visit.status == 'Confirmed' ? GruhaColors.verifiedBg : GruhaColors.alertBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              visit.status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: visit.status == 'Confirmed' ? GruhaColors.verifiedGreen : GruhaColors.alertOrange,
                              ),
                            ),
                          ),
                          Text(
                            'Gate Pass: ${visit.gatePasscode ?? "GP-8492"}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: GruhaColors.navy900),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        visit.propertyTitle,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: GruhaColors.textDark),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 14, color: GruhaColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '${visit.date} • ${visit.timeSlot}',
                            style: const TextStyle(fontSize: 11, color: GruhaColors.textMuted),
                          ),
                        ],
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

  Widget _buildMetricTile(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: GruhaColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(count, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: GruhaColors.navy900)),
            Text(title, style: const TextStyle(fontSize: 11, color: GruhaColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: GruhaColors.navy50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: GruhaColors.navy900, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: GruhaColors.textMuted)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: GruhaColors.textMuted),
      onTap: onTap,
    );
  }
}
