import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_color.dart';
import '../../core/constants/app_strings.dart';
import '../customer_dashboard/customer_dashboard_screen.dart';
import 'sign_in_screen.dart';

class GuestOtpScreen extends StatefulWidget {
  const GuestOtpScreen({super.key});

  @override
  State<GuestOtpScreen> createState() => _GuestOtpScreenState();
}

class _GuestOtpScreenState extends State<GuestOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    if (!_otpSent) {
      setState(() => _otpSent = true);
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const CustomerDashboardScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();

    return AuthScaffold(
      title: language.translate('Continue as guest', 'Endelea kama mgeni'),
      subtitle: language.translate(
        'Use your phone number to receive a one-time code and track a trip.',
        'Tumia namba yako ya simu kupokea msimbo wa mara moja na kufuatilia safari.',
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthTextField(
              controller: _phoneController,
              label: language.translate('Phone number', 'Namba ya simu'),
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.trim().length < 9
                  ? language.translate(
                      'Enter a valid phone number.',
                      'Weka namba ya simu sahihi.',
                    )
                  : null,
            ),
            if (_otpSent) ...[
              const SizedBox(height: 14),
              AuthTextField(
                controller: _otpController,
                label: language.translate('6-digit OTP', 'OTP ya tarakimu 6'),
                icon: Icons.lock_clock_outlined,
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.trim().length != 6
                    ? language.translate(
                        'Enter the 6-digit OTP.',
                        'Weka OTP ya tarakimu 6.',
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  language.translate(
                    'Demo OTP: 123456',
                    'OTP ya majaribio: 123456',
                  ),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 22),
            PrimaryAuthButton(
              label: language.translate(
                _otpSent ? 'Verify and continue' : 'Send OTP',
                _otpSent ? 'Thibitisha na endelea' : 'Tuma OTP',
              ),
              onPressed: _continue,
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              ),
              child: Text(
                language.translate('Sign in instead', 'Ingia badala yake'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
