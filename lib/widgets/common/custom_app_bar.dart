import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import '../../providers/app_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showCitySelector;
  final VoidCallback? onNotificationTap;

  const CustomAppBar({
    super.key,
    this.showCitySelector = true,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      scrolledUnderElevation: 1.5,
      titleSpacing: 16,
      title: Row(
        children: [
          // Brand Logo
          Image.asset(
            'assets/images/logo_GruhaSankalp.png',
            height: 38,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: GruhaColors.navy900,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'GS',
                    style: TextStyle(
                      color: GruhaColors.gold400,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'GruhaSankalp',
                  style: TextStyle(
                    color: GruhaColors.navy900,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // City Selector Dropdown
          if (showCitySelector)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: GruhaColors.navy50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: GruhaColors.borderLight),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: appState.selectedCity,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: GruhaColors.navy900),
                  isDense: true,
                  style: const TextStyle(
                    color: GruhaColors.navy900,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  items: AppConstants.popularCities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, size: 12, color: GruhaColors.gold600),
                          const SizedBox(width: 4),
                          Text(city == 'All' ? 'All India' : city),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newCity) {
                    if (newCity != null) {
                      appState.setSelectedCity(newCity);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
      actions: [
        // Notification Bell with Badge
        IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_outlined, size: 24, color: GruhaColors.navy900),
              if (appState.unreadNotificationsCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: GruhaColors.dealRed,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${appState.unreadNotificationsCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: onNotificationTap ?? () => _showNotificationsSheet(context),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final state = ctx.watch<AppState>();
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: GruhaColors.navy900,
                      ),
                    ),
                    Text(
                      '${state.notifications.length} alerts',
                      style: const TextStyle(
                        fontSize: 13,
                        color: GruhaColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: state.notifications.isEmpty
                    ? const Center(
                        child: Text('No notifications yet'),
                      )
                    : ListView.separated(
                        itemCount: state.notifications.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (ctx, idx) {
                          final item = state.notifications[idx];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: item.read ? GruhaColors.navy50 : GruhaColors.gold50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_active,
                                color: item.read ? GruhaColors.navy600 : GruhaColors.gold600,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: item.read ? FontWeight.w600 : FontWeight.w800,
                                color: GruhaColors.textDark,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                item.message,
                                style: const TextStyle(fontSize: 12, color: GruhaColors.textBody),
                              ),
                            ),
                            onTap: () {
                              state.markNotificationRead(item.id);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
