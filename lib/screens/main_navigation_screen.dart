import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/common/bottom_nav_bar.dart';
import '../widgets/common/custom_app_bar.dart';
import 'ai_assistant_screen.dart';
import 'dashboards/buyer_dashboard_screen.dart';
import 'home_screen.dart';
import 'saved_properties_screen.dart';
import 'search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    SavedPropertiesScreen(),
    BuyerDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentIndex = appState.currentBottomNavIndex;

    return Scaffold(
      extendBody: true,
      appBar: currentIndex == 0 ? const CustomAppBar() : null,
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: GruhaBottomNavBar(
        currentIndex: currentIndex,
        onTabSelected: (index) {
          appState.setBottomNavIndex(index);
        },
        onAiPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AiAssistantScreen(),
            ),
          );
        },
      ),
    );
  }
}

