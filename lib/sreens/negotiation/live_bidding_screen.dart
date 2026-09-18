import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_color.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/language_switcher_pill.dart';
import '../tracking/live_location_screen.dart';

class LiveBiddingScreen extends StatefulWidget {
  final String cargoType;
  final double weightTonnes;
  final String pickupLocation;
  final String destination;
  final String targetPriceTzs;
  final String truckType;
  final DateTime? journeyDate;

  const LiveBiddingScreen({
    super.key,
    required this.cargoType,
    required this.weightTonnes,
    required this.pickupLocation,
    required this.destination,
    required this.targetPriceTzs,
    required this.truckType,
    this.journeyDate,
  });

  @override
  State<LiveBiddingScreen> createState() => _LiveBiddingScreenState();
}

class _LiveBiddingScreenState extends State<LiveBiddingScreen> {
  final TextEditingController _counterController = TextEditingController();
  Timer? _searchTimer;
  bool _searchingNearby = true;
  Map<String, dynamic>? _acceptedBid;

  // Simulated live driver bids
  final List<Map<String, dynamic>> _bids = [
    {
      'driverName': 'Juma Rashid',
      'rating': '4.9 ⭐',
      'trips': '142 trips',
      'truckModel': 'Small Bajaji',
      'plateNumber': 'T 482 DSK',
      'latraVerified': true,
      'bidAmount': '165,000',
      'eta': '12 mins away',
    },
    {
      'driverName': 'Suleiman Mussa',
      'rating': '4.8 ⭐',
      'trips': '98 trips',
      'truckModel': 'Gutter / Pickup',
      'plateNumber': 'T 910 EAB',
      'latraVerified': true,
      'bidAmount': '140,000',
      'eta': '18 mins away',
    },
    {
      'driverName': 'Godfrey Temba',
      'rating': '4.7 ⭐',
      'trips': '64 trips',
      'truckModel': 'Small Bajaji',
      'plateNumber': 'T 204 DEG',
      'latraVerified': false,
      'bidAmount': '125,000',
      'eta': '22 mins away',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _searchingNearby = false);
    });
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      appBar: AppBar(
        title: Text(
          lang.translate('Negotiation offers', 'Ofa za mazungumzo'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: const [LanguageSwitcherPill()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ACTIVE REQUEST SUMMARY CARD
            _buildRequestSummaryCard(lang),

            const SizedBox(height: 16),

            _buildNearbySearchCard(lang),

            const SizedBox(height: 16),

            // 2. LIVE BID STATUS HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryAmber,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lang.translate(
                        'Incoming Driver Offers',
                        'Ofa za Madereva Inazoingia',
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successGreenBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_bids.length} ${lang.translate('Bids', 'Zabuni')}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.successGreen,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 3. DRIVER BID CARDS
            if (_acceptedBid == null)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _bids.length,
                itemBuilder: (context, index) {
                  final bid = _bids[index];
                  return _buildBidCard(context, lang, bid);
                },
              )
            else
              _buildAcceptedTripCard(lang),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbySearchCard(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _searchingNearby ? AppColors.darkNavy : AppColors.successGreenBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (_searchingNearby)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primaryAmber,
              ),
            )
          else
            const Icon(
              Icons.check_circle,
              color: AppColors.successGreen,
              size: 24,
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _searchingNearby
                  ? lang.translate(
                      'Finding nearby drivers for your route...',
                      'Tunatafuta madereva wa karibu kwa njia yako...',
                    )
                  : lang.translate(
                      'Nearby drivers found. Choose an offer below.',
                      'Madereva wa karibu wamepatikana. Chagua ofa hapa chini.',
                    ),
              style: TextStyle(
                color: _searchingNearby ? Colors.white : AppColors.successGreen,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptedTripCard(LanguageProvider lang) {
    final bid = _acceptedBid!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successGreenBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.successGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: AppColors.successGreen),
              const SizedBox(width: 8),
              Text(
                lang.translate('Route accepted', 'Njia imekubaliwa'),
                style: const TextStyle(
                  color: AppColors.successGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${widget.pickupLocation} → ${widget.destination}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${bid['driverName']} • ${bid['truckModel']}',
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LiveLocationScreen()),
              ),
              icon: const Icon(Icons.location_on_outlined),
              label: Text(lang.translate('Track trip', 'Fuatilia safari')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAmber,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Active Request Summary
  Widget _buildRequestSummaryCard(LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '#REQ-LIVE',
                style: TextStyle(fontSize: 11, color: Colors.white60),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryAmber,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.truckType,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.cargoType} (${widget.weightTonnes} T)',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          if (widget.journeyDate != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Colors.white70,
                ),
                const SizedBox(width: 6),
                Text(
                  '${widget.journeyDate!.day}/${widget.journeyDate!.month}/${widget.journeyDate!.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],
          Row(
            children: [
              const Icon(Icons.route, size: 14, color: Colors.white70),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${widget.pickupLocation} ➔ ${widget.destination}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.translate('Your target offer:', 'Bei unayopendekeza:'),
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              Text(
                'TZS ${widget.targetPriceTzs}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Individual Driver Offer Card
  Widget _buildBidCard(
    BuildContext context,
    LanguageProvider lang,
    Map<String, dynamic> bid,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver details header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.surfaceAlt,
                child: const Icon(Icons.person, color: AppColors.darkNavy),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          bid['driverName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (bid['latraVerified'])
                          const Icon(
                            Icons.verified,
                            color: AppColors.successGreen,
                            size: 16,
                          ),
                      ],
                    ),
                    Text(
                      '${bid['rating']} • ${bid['trips']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'TZS ${bid['bidAmount']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryAmber,
                    ),
                  ),
                  Text(
                    bid['eta'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Vehicle info badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      bid['truckModel'],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  bid['plateNumber'],
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkNavy,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Action buttons (Accept / Counter Offer)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.darkNavy),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _showCounterOfferDialog(context, lang, bid),
                  child: Text(
                    lang.translate('Counter Offer', 'Toa Zabuni Mbadala'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.darkNavy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAmber,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _acceptBid(lang, bid),
                  child: Text(
                    lang.translate('Accept Bid', 'Kubali Ofa'),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _acceptBid(LanguageProvider lang, Map<String, dynamic> bid) {
    setState(() => _acceptedBid = bid);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lang.translate(
            'Driver accepted your route. Trip confirmed.',
            'Dereva amekubali njia yako. Safari imethibitishwa.',
          ),
        ),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  // Counter Offer Modal Popup
  void _showCounterOfferDialog(
    BuildContext context,
    LanguageProvider lang,
    Map<String, dynamic> bid,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            lang.translate('Send Counter Offer', 'Tuma Ofa Mbadala'),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${lang.translate('Driver Bid:', 'Ofa ya Dereva:')} TZS ${bid['bidAmount']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _counterController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: lang.translate(
                    'Your Counter Offer (TZS)',
                    'Ofa Yako Mbadala (TZS)',
                  ),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(lang.translate('Cancel', 'Ghairi')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAmber,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      lang.translate(
                        'Counter offer sent to driver.',
                        'Ofa mbadala imetumwa kwa dereva.',
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                lang.translate('Send', 'Tuma'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
