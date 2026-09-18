import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_color.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/language_switcher_pill.dart';
import '../../widgets/app_side_drawer.dart';

class LiveLocationScreen extends StatefulWidget {
  const LiveLocationScreen({super.key});

  @override
  State<LiveLocationScreen> createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {
  bool _sharing = false;
  Timer? _chartTimer;
  final List<double> _speedReadings = [38, 42, 40, 46, 44, 48, 45];

  @override
  void dispose() {
    _chartTimer?.cancel();
    super.dispose();
  }

  void _toggleSharing() {
    setState(() => _sharing = !_sharing);
    if (_sharing) {
      _chartTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!mounted) return;
        setState(() {
          final next = (_speedReadings.last + 2.5) % 18 + 34;
          _speedReadings.add(next);
          if (_speedReadings.length > 12) _speedReadings.removeAt(0);
        });
      });
    } else {
      _chartTimer?.cancel();
      _chartTimer = null;
    }
  }

  Future<void> _callDriver() async {
    final phoneUri = Uri(scheme: 'tel', path: '+255700000000');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to open the phone dialer.')),
    );
  }

  Future<void> _messageDriver() async {
    final messageUri = Uri(
      scheme: 'sms',
      path: '+255700000000',
      queryParameters: {
        'body': 'Hello, I am contacting you about trip TRK-4821.',
      },
    );
    if (await canLaunchUrl(messageUri)) {
      await launchUrl(messageUri);
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to open the messaging app.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      drawer: const AppSideDrawer(),
      appBar: AppBar(
        title: Text(
          language.translate('Live location', 'Mahali mubashara'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: const [LanguageSwitcherPill()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFDCE5E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderNeutral),
              ),
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: CustomPaint(painter: _MapGridPainter()),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.alertRed,
                      size: 46,
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top: 18,
                    child: _MapLabel(
                      label: language.translate(
                        'Current vehicle position',
                        'Mahali pa gari sasa',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _LiveTripChart(
              readings: _speedReadings,
              language: language,
              active: _sharing,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _callDriver,
                    icon: const Icon(Icons.phone_outlined),
                    label: Text(language.translate('Call', 'Piga simu')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkNavy,
                      side: const BorderSide(color: AppColors.darkNavy),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _messageDriver,
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: Text(language.translate('Message', 'Ujumbe')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryAmber,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              language.translate(
                'Share trip location',
                'Shiriki mahali pa safari',
              ),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              language.translate(
                'Give this tracking code to the customer or driver.',
                'Mpe mteja au dereva msimbo huu wa kufuatilia.',
              ),
              style: const TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderNeutral),
              ),
              child: Row(
                children: [
                  const Icon(Icons.key_outlined, color: AppColors.primaryAmber),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'TRK-4821',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                        color: AppColors.darkNavy,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: language.translate('Copy code', 'Nakili msimbo'),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          language.translate(
                            'Tracking code copied.',
                            'Msimbo wa ufuatiliaji umenakiliwa.',
                          ),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.copy_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _toggleSharing,
                icon: Icon(
                  _sharing
                      ? Icons.stop_circle_outlined
                      : Icons.share_location_outlined,
                ),
                label: Text(
                  language.translate(
                    _sharing ? 'Stop sharing location' : 'Start live sharing',
                    _sharing
                        ? 'Acha kushiriki mahali'
                        : 'Anza kushiriki mahali',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _sharing
                      ? AppColors.darkNavy
                      : AppColors.primaryAmber,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            if (_sharing) ...[
              const SizedBox(height: 12),
              Text(
                language.translate(
                  'Live sharing is active for this trip.',
                  'Kushiriki mahali mubashara kumeanza kwa safari hii.',
                ),
                style: const TextStyle(
                  color: AppColors.successGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LiveTripChart extends StatelessWidget {
  const _LiveTripChart({
    required this.readings,
    required this.language,
    required this.active,
  });

  final List<double> readings;
  final LanguageProvider language;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language.translate('Live speed', 'Kasi mubashara'),
                style: const TextStyle(
                  color: AppColors.textMain,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${readings.last.toStringAsFixed(0)} km/h',
                style: const TextStyle(
                  color: AppColors.primaryAmber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            active
                ? language.translate('Updating now', 'Inasasishwa sasa')
                : language.translate(
                    'Start sharing to update',
                    'Anza kushiriki kusasisha',
                  ),
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 110,
            width: double.infinity,
            child: CustomPaint(painter: _SpeedChartPainter(readings: readings)),
          ),
        ],
      ),
    );
  }
}

class _SpeedChartPainter extends CustomPainter {
  const _SpeedChartPainter({required this.readings});

  final List<double> readings;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.borderNeutral
      ..strokeWidth = 1;
    for (var y = 0.0; y <= size.height; y += size.height / 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[];
    final minValue = 30.0;
    final maxValue = 60.0;
    for (var index = 0; index < readings.length; index++) {
      final x = readings.length == 1
          ? size.width / 2
          : index * size.width / (readings.length - 1);
      final normalized = (readings[index] - minValue) / (maxValue - minValue);
      points.add(Offset(x, size.height - normalized.clamp(0, 1) * size.height));
    }

    final linePaint = Paint()
      ..color = AppColors.primaryAmber
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = AppColors.darkNavy;
    canvas.drawCircle(points.last, 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _SpeedChartPainter oldDelegate) =>
      oldDelegate.readings != readings;
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 6)],
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x66788B83)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 36) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
    for (var y = 0.0; y < size.height; y += 42) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 22), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
