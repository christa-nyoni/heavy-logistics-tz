import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_color.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/language_switcher_pill.dart';
import '../../widgets/app_side_drawer.dart';
import '../heavy_transport/heavy_transport_request_screen.dart';
import '../tracking/live_location_screen.dart';
import '../request_screen/request_page.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      drawer: const AppSideDrawer(),
      appBar: AppBar(
        title: Text(
          lang.translate('Customer Dashboard', 'Dashibodi ya Mteja'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: const [LanguageSwitcherPill()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. WELCOME BANNER
            Text(
              lang.translate(
                'Good morning, Freight Client',
                'Habari za asubuhi, Mteja',
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lang.translate(
                'Manage your heavy freight deliveries and bids in one place.',
                'Simamia usafirishaji wa mizigo na zabuni zako sehemu moja.',
              ),
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),

            const SizedBox(height: 20),

            // 2. METRICS OVERVIEW CARDS (GRID)
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: lang.translate(
                      'Active Trips',
                      'Safari Zinazoendelea',
                    ),
                    value: '2',
                    icon: Icons.local_shipping_outlined,
                    iconColor: AppColors.primaryAmber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: lang.translate('Scheduled', 'Zilizowekewa Miadi'),
                    value: '4',
                    icon: Icons.calendar_today_outlined,
                    iconColor: AppColors.darkNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: lang.translate('Total Tonnage', 'Jumla ya Tani'),
                    value: '142 T',
                    icon: Icons.scale_outlined,
                    iconColor: AppColors.successGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: lang.translate('Total Spent', 'Jumla ya Gharama'),
                    value: 'TZS 4.2M',
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.primaryAmber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 3. SERVICE HUB: instant city delivery or scheduled corridor freight
            Text(
              lang.translate('Choose a service', 'Chagua huduma'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lang.translate(
                'Request now like a city ride, or schedule freight like a station-to-station journey.',
                'Omba sasa kama safari ya mjini, au panga mzigo kama safari ya kituo hadi kituo.',
              ),
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildServiceCard(
                    context: context,
                    title: lang.translate('Move now', 'Safirisha sasa'),
                    subtitle: lang.translate(
                      'City delivery',
                      'Usafirishaji wa mjini',
                    ),
                    detail: lang.translate(
                      'Bajaji or gutter',
                      'Bajaji au gutter',
                    ),
                    icon: Icons.bolt_outlined,
                    color: AppColors.primaryAmber,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RequestPage()),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildServiceCard(
                    context: context,
                    title: lang.translate('Schedule freight', 'Panga mzigo'),
                    subtitle: lang.translate(
                      'Intercity corridor',
                      'Njia ya miji',
                    ),
                    detail: lang.translate(
                      'Heavy truck journey',
                      'Safari ya lori zito',
                    ),
                    icon: Icons.train_outlined,
                    color: AppColors.darkNavy,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HeavyTransportRequestScreen(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LiveLocationScreen()),
                ),
                icon: const Icon(Icons.location_on_outlined),
                label: Text(
                  lang.translate(
                    'Track a live trip',
                    'Fuatilia safari mubashara',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 4. RECENT SHIPMENTS / REQUESTS LIST
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang.translate(
                    'Recent Requests & Trips',
                    'Maombi na Safari za Hivi Karibuni',
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    lang.translate('View All', 'Ona Zote'),
                    style: const TextStyle(
                      color: AppColors.primaryAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // RECENT TRIP TILES
            _buildTripTile(
              context: context,
              requestId: '#REQ-8821',
              cargo: '28T Cement Bulk',
              route: 'Dar es Salaam Port ➔ Dodoma',
              bookingType: lang.translate('Instant', 'Sasa hivi'),
              status: lang.translate('In Transit', 'Njiani'),
              statusColor: AppColors.primaryAmber,
              statusBg: AppColors.surfaceAlt,
            ),
            const SizedBox(height: 10),
            _buildTripTile(
              context: context,
              requestId: '#REQ-8819',
              cargo: '10T Steel Reinforcements',
              route: 'Tanga ➔ Morogoro',
              bookingType: lang.translate(
                'Scheduled (Sep 18)',
                'Miadi (18 Sep)',
              ),
              status: lang.translate(
                'Bids Received (3)',
                'Zabuni Zimepokelewa (3)',
              ),
              statusColor: AppColors.successGreen,
              statusBg: AppColors.successGreenBg,
            ),
            const SizedBox(height: 10),
            _buildTripTile(
              context: context,
              requestId: '#REQ-8790',
              cargo: '56T Heavy Excavator Plant',
              route: 'Mtwara ➔ Dar es Salaam',
              bookingType: lang.translate('Instant', 'Sasa hivi'),
              status: lang.translate('Delivered', 'Imefikishwa'),
              statusColor: AppColors.darkNavy,
              statusBg: AppColors.surfaceAlt,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String detail,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 158,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderNeutral),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 28),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    detail,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.arrow_forward, color: color, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Metric Card Helper Widget
  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderNeutral, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: iconColor, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
        ],
      ),
    );
  }

  // Recent Trip List Tile Widget
  Widget _buildTripTile({
    required BuildContext context,
    required String requestId,
    required String cargo,
    required String route,
    required String bookingType,
    required String status,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderNeutral, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                requestId,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            cargo,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.route, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  route,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 12,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                bookingType,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
