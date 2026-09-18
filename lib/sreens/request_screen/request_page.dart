import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_color.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/language_switcher_pill.dart';
import '../negotiation/live_bidding_screen.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  // Booking Type State: Instant vs Scheduled
  bool isInstant = true;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String selectedRouteType = 'within_city';

  // Form Controllers
  final TextEditingController _pickupController = TextEditingController(
    text: 'Kariakoo Market',
  );
  final TextEditingController _destinationController = TextEditingController(
    text: 'Mbezi Beach',
  );
  final TextEditingController _budgetController = TextEditingController(
    text: '150,000',
  );

  // Cargo & Weight State
  double cargoWeight = 1.5;
  String selectedCargoType = 'Household Goods';

  final List<String> cargoTypesEn = [
    'Household Goods',
    'Retail Stock',
    'Building Materials',
    'Agricultural Produce',
    'General Cargo',
  ];

  final List<String> cargoTypesSw = [
    'Bidhaa za Nyumbani',
    'Hisa za Rejareja',
    'Vifaa vya Ujenzi',
    'Mazao ya Kilimo',
    'Mizigo ya Kawaida',
  ];

  // Vehicle Selection State
  int selectedTruckIndex = 1; // Default small Bajaji / Gutter option
  final List<Map<String, dynamic>> truckTypes = [
    {
      'title': 'Small Bajaji',
      'maxWeight': 0.7,
      'icon': Icons.electric_rickshaw_outlined,
      'descEn': 'Short local errands',
      'descSw': 'Safari fupi za ndani ya jiji',
    },
    {
      'title': 'Gutter / Pickup',
      'maxWeight': 1.5,
      'icon': Icons.local_shipping_outlined,
      'descEn': 'Short city / local loads',
      'descSw': 'Mizigo fupi ya ndani ya jiji',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final double maxCapacity = truckTypes[selectedTruckIndex]['maxWeight'];
    final bool isOverloaded = cargoWeight > maxCapacity;
    final bool isWithinCity = selectedRouteType == 'within_city';

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(
        title: Text(
          lang.translate('New Transport Request', 'Ombi Jipya la Usafiri'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: const [LanguageSwitcherPill()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ROUTE TYPE: within city vs outside region
            _buildRouteTypeSelector(lang),

            const SizedBox(height: 14),

            // 2. SHIP NOW VS SCHEDULE TOGGLE
            _buildJourneyTimingSelector(lang),

            if (!isInstant) ...[
              const SizedBox(height: 12),
              _buildDateTimePicker(lang),
            ],

            const SizedBox(height: 16),

            // 3. ROUTE LOCATIONS CARD
            _buildSectionHeader(
              lang.translate('ROUTE DETAILS', 'MAELEZO YA NJIA'),
            ),
            const SizedBox(height: 6),
            _buildRouteCard(lang, isWithinCity),

            const SizedBox(height: 16),

            // 3. CARGO & TANROADS WEIGHT SLIDER
            _buildSectionHeader(
              lang.translate('CARGO & WEIGHT', 'AINA NA UZITO WA MZIGO'),
            ),
            const SizedBox(height: 6),
            _buildCargoCard(lang, isOverloaded, maxCapacity),

            const SizedBox(height: 16),

            // 4. VEHICLE SELECTION CAROUSEL
            _buildSectionHeader(
              lang.translate('SELECT VEHICLE TYPE', 'CHAGUA AINA YA GARI'),
            ),
            const SizedBox(height: 8),
            _buildVehicleCarousel(lang),

            const SizedBox(height: 16),

            // 5. BUDGET INPUT CARD
            _buildSectionHeader(
              lang.translate('TARGET OFFER', 'BEI UNAYOPENDEKEZA'),
            ),
            const SizedBox(height: 6),
            _buildBudgetCard(lang),

            const SizedBox(height: 24),

            // 6. SUBMIT REQUEST BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOverloaded
                      ? Colors.grey
                      : AppColors.primaryAmber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: isOverloaded ? null : () => _confirmAndSubmit(lang),
                child: Text(
                  isInstant
                      ? lang.translate(
                          'Submit & Broadcast Request ➔',
                          'Tuma Ombi Sasa ➔',
                        )
                      : lang.translate(
                          'Confirm Scheduled Request ➔',
                          'Thibitisha Ombi la Miadi ➔',
                        ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndSubmit(LanguageProvider lang) async {
    final truckType = truckTypes[selectedTruckIndex]['title'] as String;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(lang.translate('Confirm route', 'Thibitisha njia')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.translate('Route', 'Njia'),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_pickupController.text}  →  ${_destinationController.text}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              lang.translate('Vehicle', 'Gari'),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              truckType,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(lang.translate('Edit', 'Hariri')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryAmber,
            ),
            child: Text(lang.translate('Confirm', 'Thibitisha')),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveBiddingScreen(
          cargoType: selectedCargoType,
          weightTonnes: cargoWeight,
          pickupLocation: _pickupController.text,
          destination: _destinationController.text,
          targetPriceTzs: _budgetController.text,
          truckType: truckType,
          journeyDate: selectedDate,
        ),
      ),
    );
  }

  // Section Header Helper
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _buildRouteTypeSelector(LanguageProvider lang) {
    final routeOptions = [
      lang.translate('Within City', 'Ndani ya Jiji'),
      lang.translate('Outside Region', 'Nje ya Mkoa'),
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Row(
        children: List.generate(routeOptions.length, (index) {
          final isSelected =
              (index == 0 && selectedRouteType == 'within_city') ||
              (index == 1 && selectedRouteType == 'outside_region');

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                selectedRouteType = index == 0
                    ? 'within_city'
                    : 'outside_region';
                if (selectedRouteType == 'within_city') {
                  _pickupController.text = 'Kariakoo Market';
                  _destinationController.text = 'Mbezi Beach';
                } else {
                  _pickupController.text = 'Dar es Salaam';
                  _destinationController.text = 'Morogoro';
                }
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryAmber
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    routeOptions[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isSelected ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Toggle Switcher (Ship Now / Schedule)
  Widget _buildJourneyTimingSelector(LanguageProvider lang) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final isTomorrow =
        selectedDate != null &&
        selectedDate!.year == tomorrow.year &&
        selectedDate!.month == tomorrow.month &&
        selectedDate!.day == tomorrow.day;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          lang.translate('WHEN IS THE JOURNEY?', 'SAFARI NI LINI?'),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _timingButton(
                label: lang.translate('Now', 'Sasa'),
                icon: Icons.bolt_outlined,
                selected: isInstant,
                onTap: () => setState(() {
                  isInstant = true;
                  selectedDate = null;
                }),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _timingButton(
                label: lang.translate('Tomorrow', 'Kesho'),
                icon: Icons.today_outlined,
                selected: !isInstant && isTomorrow,
                onTap: () => setState(() {
                  isInstant = false;
                  selectedDate = tomorrow;
                }),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _timingButton(
                label: lang.translate('Choose date', 'Chagua tarehe'),
                icon: Icons.date_range_outlined,
                selected: !isInstant && !isTomorrow,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? tomorrow,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) {
                    setState(() {
                      isInstant = false;
                      selectedDate = picked;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        if (!isInstant && selectedDate != null) ...[
          const SizedBox(height: 8),
          Text(
            '${lang.translate('Journey date: ', 'Tarehe ya safari: ')}${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.darkNavy,
            ),
          ),
        ],
      ],
    );
  }

  Widget _timingButton({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        backgroundColor: selected
            ? AppColors.primaryAmber
            : AppColors.surfaceCard,
        foregroundColor: selected ? Colors.white : AppColors.textMain,
        side: BorderSide(
          color: selected ? AppColors.primaryAmber : AppColors.borderNeutral,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 17),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  // Scheduled Date & Time Picker
  Widget _buildDateTimePicker(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(
                Icons.date_range,
                size: 16,
                color: AppColors.darkNavy,
              ),
              label: Text(
                selectedDate == null
                    ? lang.translate('Select Date', 'Chagua Tarehe')
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                style: const TextStyle(fontSize: 12, color: AppColors.textMain),
              ),
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.darkNavy,
              ),
              label: Text(
                selectedTime == null
                    ? lang.translate('Select Time', 'Chagua Muda')
                    : selectedTime!.format(context),
                style: const TextStyle(fontSize: 12, color: AppColors.textMain),
              ),
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) setState(() => selectedTime = picked);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Pickup & Dropoff Inputs
  Widget _buildRouteCard(LanguageProvider lang, bool isWithinCity) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.circle, color: Colors.green, size: 12),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _pickupController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: isWithinCity
                        ? lang.translate('Pickup Area', 'Eneo la Kuchukulia')
                        : lang.translate('Origin Region', 'Mkoa wa Kutoka'),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.alertRed,
                size: 14,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _destinationController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: isWithinCity
                        ? lang.translate('Dropoff Area', 'Eneo la Kufikisha')
                        : lang.translate(
                            'Destination Region',
                            'Mkoa wa Kufikisha',
                          ),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Cargo Dropdown & Weight Slider with TANROADS Warning
  Widget _buildCargoCard(
    LanguageProvider lang,
    bool isOverloaded,
    double maxCapacity,
  ) {
    final cargoList = lang.isSwahili ? cargoTypesSw : cargoTypesEn;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            initialValue: cargoList.contains(selectedCargoType)
                ? selectedCargoType
                : cargoList.first,
            items: cargoList
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type, style: const TextStyle(fontSize: 13)),
                  ),
                )
                .toList(),
            onChanged: (val) => setState(() => selectedCargoType = val!),
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.translate('Weight (Tonnes)', 'Uzito (Tani)'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                '${cargoWeight.toStringAsFixed(1)} T',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isOverloaded
                      ? AppColors.alertRed
                      : AppColors.primaryAmber,
                ),
              ),
            ],
          ),
          Slider(
            value: cargoWeight,
            min: 0.5,
            max: 3.0,
            divisions: 25,
            activeColor: isOverloaded
                ? AppColors.alertRed
                : AppColors.primaryAmber,
            onChanged: (val) => setState(() => cargoWeight = val),
          ),

          if (isOverloaded)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.alertRedBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.alertRed),
              ),
              child: Text(
                lang.translate(
                  '⚠️ Capacity alert: $cargoWeight T exceeds the selected small-vehicle limit ($maxCapacity T). Choose a lighter load or smaller route.',
                  '⚠️ Uwezo umezidi: Tani $cargoWeight inazidi kikomo cha gari ndogo ($maxCapacity T). Chagua mzigo mwembamba au njia fupi.',
                ),
                style: const TextStyle(
                  color: AppColors.alertRed,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Vehicle Selection Horizontal List
  Widget _buildVehicleCarousel(LanguageProvider lang) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: truckTypes.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedTruckIndex == index;
          var truck = truckTypes[index];
          return GestureDetector(
            onTap: () => setState(() => selectedTruckIndex = index),
            child: Container(
              width: 130,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFFBEB)
                    : AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryAmber
                      : AppColors.borderNeutral,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    truck['icon'],
                    color: isSelected
                        ? AppColors.primaryAmber
                        : AppColors.textMuted,
                    size: 20,
                  ),
                  Text(
                    truck['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    lang.translate(truck['descEn'], truck['descSw']),
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Target Budget Card
  Widget _buildBudgetCard(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: TextField(
        controller: _budgetController,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        decoration: const InputDecoration(
          prefixText: 'TZS ',
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      ),
    );
  }
}
