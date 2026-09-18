import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_color.dart';
import '../../core/constants/app_strings.dart';
import '../auth/sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      titleEn: 'Move heavy freight with confidence',
      titleSw: 'Safirisha mizigo mizito kwa uhakika',
      bodyEn:
          'Find the right truck for every load, route, and delivery window.',
      bodySw: 'Pata lori sahihi kwa kila mzigo, njia, na muda wa usafirishaji.',
    ),
    _OnboardingPage(
      titleEn: 'Compare verified driver bids',
      titleSw: 'Linganisha zabuni za madereva waliothibitishwa',
      bodyEn:
          'See offers clearly and choose the carrier that fits your budget.',
      bodySw:
          'Tazama ofa kwa uwazi na uchague msafirishaji anayelingana na bajeti yako.',
    ),
    _OnboardingPage(
      titleEn: 'Keep every trip on track',
      titleSw: 'Simamia kila safari kwa urahisi',
      bodyEn:
          'Manage requests, scheduled trips, and active deliveries in one place.',
      bodySw:
          'Simamia maombi, safari zilizopangwa, na usafirishaji unaoendelea sehemu moja.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_currentPage == _pages.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backgroundOffWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Safari Truck',
                    style: TextStyle(
                      color: AppColors.darkNavy,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => language.toggleLanguage(),
                    icon: const Icon(Icons.language, size: 16),
                    label: Text(language.isSwahili ? 'SW' : 'EN'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.darkNavy,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (_, index) {
                    final item = _pages[index];
                    return _OnboardingContent(item: item, language: language);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 7,
                    width: index == _currentPage ? 24 : 7,
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? AppColors.primaryAmber
                          : AppColors.borderNeutral,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAmber,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    language.translate(
                      isLastPage ? 'Get started' : 'Continue',
                      isLastPage ? 'Anza sasa' : 'Endelea',
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                ),
                child: Text(
                  language.translate('Skip', 'Ruka'),
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({required this.item, required this.language});

  final _OnboardingPage item;
  final LanguageProvider language;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          key: ValueKey(item.titleEn),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 22 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.darkNavy,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x220F172A),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset('assets/truck_icon.jpeg', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 42),
        Text(
          language.translate(item.titleEn, item.titleSw),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textMain,
            fontSize: 28,
            height: 1.12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          language.translate(item.bodyEn, item.bodySw),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.titleEn,
    required this.titleSw,
    required this.bodyEn,
    required this.bodySw,
  });

  final String titleEn;
  final String titleSw;
  final String bodyEn;
  final String bodySw;
}
