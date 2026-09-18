import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_color.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/theme_provider.dart';
import 'sreens/onboarding/onboarding_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const HeavyLogisticsCustomerApp(),
    ),
  );
}

class HeavyLogisticsCustomerApp extends StatelessWidget {
  const HeavyLogisticsCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Safari Truck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundOffWhite,
        primaryColor: AppColors.primaryAmber,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryAmber,
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkNavy,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF101820),
        cardColor: const Color(0xFF182632),
        primaryColor: AppColors.primaryAmber,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryAmber,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkNavy,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF182632),
        ),
      ),
      themeMode: theme.themeMode,
      home: const OnboardingScreen(),
    );
  }
}
