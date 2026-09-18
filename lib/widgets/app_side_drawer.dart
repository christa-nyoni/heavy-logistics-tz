import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_color.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/theme_provider.dart';
import '../sreens/auth/sign_in_screen.dart';
import '../sreens/heavy_transport/heavy_transport_request_screen.dart';
import '../sreens/request_screen/request_page.dart';
import '../sreens/tracking/live_location_screen.dart';

class AppSideDrawer extends StatelessWidget {
  const AppSideDrawer({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final theme = context.watch<ThemeProvider>();

    return Drawer(
      backgroundColor: AppColors.surfaceCard,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
              color: AppColors.darkNavy,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAmber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      language.translate('Safari Truck', 'Safari Truck'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _item(
              context,
              icon: Icons.dashboard_outlined,
              label: language.translate('Dashboard', 'Dashibodi'),
              onTap: () => Navigator.pop(context),
            ),
            _item(
              context,
              icon: Icons.bolt_outlined,
              label: language.translate(
                'Local delivery',
                'Usafirishaji wa ndani',
              ),
              onTap: () => _open(context, const RequestPage()),
            ),
            _item(
              context,
              icon: Icons.train_outlined,
              label: language.translate(
                'Scheduled freight',
                'Mzigo uliopangwa',
              ),
              onTap: () => _open(context, const HeavyTransportRequestScreen()),
            ),
            _item(
              context,
              icon: Icons.location_on_outlined,
              label: language.translate('Live location', 'Mahali mubashara'),
              onTap: () => _open(context, const LiveLocationScreen()),
            ),
            SwitchListTile.adaptive(
              secondary: Icon(
                theme.isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                color: AppColors.primaryAmber,
              ),
              title: Text(
                language.translate('Dark mode', 'Mwonekano wa giza'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              value: theme.isDarkMode,
              activeThumbColor: AppColors.primaryAmber,
              onChanged: theme.toggleTheme,
            ),
            const Spacer(),
            const Divider(height: 1),
            _item(
              context,
              icon: Icons.logout,
              label: language.translate('Sign out', 'Toka'),
              color: AppColors.alertRed,
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                (_) => false,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.textMain,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
