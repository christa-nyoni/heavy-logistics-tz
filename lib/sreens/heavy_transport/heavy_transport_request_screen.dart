import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_color.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/language_switcher_pill.dart';
import '../negotiation/live_bidding_screen.dart';

class HeavyTransportRequestScreen extends StatefulWidget {
  const HeavyTransportRequestScreen({super.key});

  @override
  State<HeavyTransportRequestScreen> createState() =>
      _HeavyTransportRequestScreenState();
}

class _HeavyTransportRequestScreenState
    extends State<HeavyTransportRequestScreen> {
  final _pickupController = TextEditingController(text: 'Dar es Salaam Port');
  final _destinationController = TextEditingController(text: 'Dodoma');
  final _budgetController = TextEditingController(text: '1,800,000');
  double _weight = 12;
  String _truckType = '10T Rigid Truck';
  bool _isToday = true;
  DateTime? _journeyDate;

  final _truckTypes = const [
    {'title': '10T Rigid Truck', 'capacity': 10.0},
    {'title': '28T Semi-Trailer', 'capacity': 28.0},
    {'title': '56T Multi-Axle', 'capacity': 56.0},
  ];

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final capacity =
        _truckTypes.firstWhere(
              (truck) => truck['title'] == _truckType,
            )['capacity']
            as double;
    final overloaded = _weight > capacity;

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(
        title: Text(
          language.translate('Heavy truck request', 'Ombi la lori zito'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: const [LanguageSwitcherPill()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              language.translate(
                'Move heavy freight from one place to another.',
                'Safirisha mzigo mzito kutoka sehemu moja hadi nyingine.',
              ),
              style: const TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 18),
            _field(
              _pickupController,
              language.translate('Origin', 'Sehemu ya kuanzia'),
              Icons.trip_origin,
            ),
            const SizedBox(height: 10),
            _field(
              _destinationController,
              language.translate('Destination', 'Sehemu ya kufikisha'),
              Icons.location_on_outlined,
            ),
            const SizedBox(height: 18),
            _buildJourneyTimingSelector(language),
            const SizedBox(height: 18),
            Text(
              language.translate('Truck type', 'Aina ya lori'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _truckType,
              items: _truckTypes
                  .map(
                    (truck) => DropdownMenuItem(
                      value: truck['title'] as String,
                      child: Text(truck['title'] as String),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _truckType = value!),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.translate('Cargo weight', 'Uzito wa mzigo'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_weight.toStringAsFixed(0)} T',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: overloaded
                        ? AppColors.alertRed
                        : AppColors.primaryAmber,
                  ),
                ),
              ],
            ),
            Slider(
              value: _weight,
              min: 1,
              max: 56,
              divisions: 55,
              onChanged: (value) => setState(() => _weight = value),
            ),
            if (overloaded)
              Text(
                language.translate(
                  'Weight exceeds this truck capacity.',
                  'Uzito unazidi uwezo wa lori hili.',
                ),
                style: const TextStyle(
                  color: AppColors.alertRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 12),
            _field(
              _budgetController,
              language.translate(
                'Target offer (TZS)',
                'Bei unayopendekeza (TZS)',
              ),
              Icons.payments_outlined,
              number: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: overloaded
                    ? null
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LiveBiddingScreen(
                            cargoType: 'Heavy freight',
                            weightTonnes: _weight,
                            pickupLocation: _pickupController.text,
                            destination: _destinationController.text,
                            targetPriceTzs: _budgetController.text,
                            truckType: _truckType,
                            journeyDate: _journeyDate,
                          ),
                        ),
                      ),
                icon: const Icon(Icons.campaign_outlined),
                label: Text(
                  language.translate(
                    'Find heavy truck offers',
                    'Tafuta ofa za malori mazito',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAmber,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool number = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: number ? TextInputType.number : TextInputType.streetAddress,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildJourneyTimingSelector(LanguageProvider language) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final isTomorrow =
        _journeyDate != null &&
        _journeyDate!.year == tomorrow.year &&
        _journeyDate!.month == tomorrow.month &&
        _journeyDate!.day == tomorrow.day;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          language.translate('Journey date', 'Tarehe ya safari'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _dateChoice(
                language.translate('Today', 'Leo'),
                Icons.bolt_outlined,
                _isToday,
                () => setState(() {
                  _isToday = true;
                  _journeyDate = null;
                }),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _dateChoice(
                language.translate('Tomorrow', 'Kesho'),
                Icons.today_outlined,
                !_isToday && isTomorrow,
                () => setState(() {
                  _isToday = false;
                  _journeyDate = tomorrow;
                }),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _dateChoice(
                language.translate('Choose date', 'Chagua'),
                Icons.date_range_outlined,
                !_isToday && !isTomorrow,
                () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _journeyDate ?? tomorrow,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) {
                    setState(() {
                      _isToday = false;
                      _journeyDate = picked;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        if (!_isToday && _journeyDate != null) ...[
          const SizedBox(height: 6),
          Text(
            '${_journeyDate!.day}/${_journeyDate!.month}/${_journeyDate!.year}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.darkNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _dateChoice(
    String label,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 2),
        backgroundColor: selected ? AppColors.primaryAmber : Colors.white,
        foregroundColor: selected ? Colors.white : AppColors.textMain,
        side: BorderSide(
          color: selected ? AppColors.primaryAmber : AppColors.borderNeutral,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
