import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_color.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/language_switcher_pill.dart';
import '../negotiation/live_bidding_screen.dart';

class BookingConfiguratorScreen extends StatefulWidget {
  const BookingConfiguratorScreen({super.key});

  @override
  State<BookingConfiguratorScreen> createState() =>
      _BookingConfiguratorScreenState();
}

class _BookingConfiguratorScreenState extends State<BookingConfiguratorScreen> {
  bool isInstant = true;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  double cargoWeight = 1.5;
  String selectedCargoType = 'Household Goods';
  final TextEditingController _budgetController = TextEditingController(
    text: '150,000',
  );
  final TextEditingController _pickupController = TextEditingController(
    text: 'Kariakoo Market',
  );
  final TextEditingController _destinationController = TextEditingController(
    text: 'Mbezi Beach',
  );

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

  int selectedTruckIndex = 1;
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
      'icon': Icons.local_shipping,
      'descEn': 'Short city / local loads',
      'descSw': 'Mizigo fupi ya ndani ya jiji',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final double maxTruckCapacity = truckTypes[selectedTruckIndex]['maxWeight'];
    final bool isOverloaded = cargoWeight > maxTruckCapacity;

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(
        title: Text(
          lang.translate('Book Local Transport', 'Agiza Usafiri wa Ndani'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: const [LanguageSwitcherPill()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. INSTANT VS SCHEDULED TOGGLE SWITCHER
            _buildBookingTypeToggle(lang),

            const SizedBox(height: 14),

            // SCHEDULED DATE & TIME PICKER (If Scheduled is selected)
            if (!isInstant) _buildDateTimePicker(lang),

            const SizedBox(height: 16),

            // 2. LOCATION INPUT CARD
            _buildLocationCard(lang),

            const SizedBox(height: 16),

            // 3. CARGO TYPE & SMALL-LOAD WEIGHT SLIDER CARD
            _buildCargoDetailsCard(lang, isOverloaded, maxTruckCapacity),

            const SizedBox(height: 20),

            // 4. TRUCK TYPE SELECTION CAROUSEL
            Text(
              lang.translate('Select Vehicle Type', 'Chagua Aina ya Gari'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 10),
            _buildTruckTypeSelector(lang),

            const SizedBox(height: 20),

            // 5. TARGET BUDGET / NEGOTIATION INPUT CARD
            _buildBudgetInputCard(lang),

            const SizedBox(height: 24),

            // 6. ACTION BUTTON
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
                onPressed: isOverloaded
                    ? null
                    : () {
                        // Navigate to Live Negotiation Bidding Terminal
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LiveBiddingScreen(
                              cargoType: selectedCargoType,
                              weightTonnes: cargoWeight,
                              pickupLocation: _pickupController.text,
                              destination: _destinationController.text,
                              targetPriceTzs: _budgetController.text,
                              truckType:
                                  truckTypes[selectedTruckIndex]['title'],
                            ),
                          ),
                        );
                      },
                child: Text(
                  isInstant
                      ? lang.translate('Broadcast Request ➔', 'Tuma Ombi ➔')
                      : lang.translate(
                          'Confirm Appointment ➔',
                          'Thibitisha Miadi ➔',
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

  // Segmented Toggle Switcher: Ship Now vs Schedule
  Widget _buildBookingTypeToggle(LanguageProvider lang) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isInstant = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isInstant
                      ? AppColors.primaryAmber
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.flash_on,
                      color: isInstant ? Colors.white : AppColors.textMuted,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      lang.translate('⚡ Ship Now', '⚡ Safirisha Sasa'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isInstant ? Colors.white : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isInstant = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isInstant
                      ? AppColors.primaryAmber
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: !isInstant ? Colors.white : AppColors.textMuted,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      lang.translate('📅 Schedule', '📅 Weka Miadi'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: !isInstant ? Colors.white : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Date & Time Picker Row for Scheduled Appointments
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
                size: 18,
                color: AppColors.darkNavy,
              ),
              label: Text(
                selectedDate == null
                    ? lang.translate('Select Date', 'Chagua Tarehe')
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
                style: const TextStyle(fontSize: 12, color: AppColors.textMain),
              ),
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(hours: 3)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(
                Icons.access_time,
                size: 18,
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

  // Location Card Widget
  Widget _buildLocationCard(LanguageProvider lang) {
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
          Text(
            lang.translate('ROUTE DETAILS', 'MAELEZO YA NJIA'),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.circle, color: Colors.green, size: 12),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _pickupController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: lang.translate(
                      'Pickup Location',
                      'Mahali pa Kuchukulia',
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
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
                    hintText: lang.translate(
                      'Destination',
                      'Mahali pa Kufikisha',
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
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

  // Cargo & Weight Component with small-vehicle capacity warning
  Widget _buildCargoDetailsCard(
    LanguageProvider lang,
    bool isOverloaded,
    double maxTruckCapacity,
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
          Text(
            lang.translate('CARGO TYPE', 'AINA YA MVIGO'),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.translate('Cargo Weight', 'Uzito wa Mizigo'),
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
            max: 1.5,
            divisions: 10,
            activeColor: isOverloaded
                ? AppColors.alertRed
                : AppColors.primaryAmber,
            onChanged: (val) => setState(() => cargoWeight = val),
          ),

          // Small-vehicle capacity warning banner
          if (isOverloaded)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.alertRedBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.alertRed),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.alertRed,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lang.translate(
                        '⚠️ Capacity alert: $cargoWeight T exceeds the selected small-vehicle limit ($maxTruckCapacity T max). Choose a lighter load.',
                        '⚠️ Uwezo umezidi: Tani $cargoWeight inazidi kikomo cha gari ndogo ($maxTruckCapacity T max). Chagua mzigo mwembamba.',
                      ),
                      style: const TextStyle(
                        color: AppColors.alertRed,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Truck Selection Horizontal Carousel
  Widget _buildTruckTypeSelector(LanguageProvider lang) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: truckTypes.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedTruckIndex == index;
          var truck = truckTypes[index];
          return GestureDetector(
            onTap: () => setState(() => selectedTruckIndex = index),
            child: Container(
              width: 135,
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
                    size: 22,
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
                    maxLines: 1,
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

  // Budget Negotiation Input Card
  Widget _buildBudgetInputCard(LanguageProvider lang) {
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
          Text(
            lang.translate(
              'TARGET OFFER (NEGOTIABLE)',
              'BEI UNAYOPENDEKEZA (INAZUNGUMZIKA)',
            ),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            decoration: const InputDecoration(
              prefixText: 'TZS ',
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildQuickPriceChip('+10k', 10000),
              const SizedBox(width: 8),
              _buildQuickPriceChip('+20k', 20000),
              const SizedBox(width: 8),
              _buildQuickPriceChip('+50k', 50000),
            ],
          ),
        ],
      ),
    );
  }

  // Quick Price Adjustment Chip Helper
  Widget _buildQuickPriceChip(String label, int increment) {
    return InkWell(
      onTap: () {
        int current =
            int.tryParse(_budgetController.text.replaceAll(',', '')) ?? 0;
        setState(() {
          _budgetController.text = (current + increment).toString();
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.borderNeutral),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavy,
          ),
        ),
      ),
    );
  }
}
