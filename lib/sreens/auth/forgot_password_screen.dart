import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import 'sign_in_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink(LanguageProvider language) {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          language.translate(
            'Reset link sent. Check your email.',
            'Kiungo cha kubadilisha nenosiri kimetumwa.',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    return AuthScaffold(
      title: language.translate(
        'Reset your password',
        'Badilisha nenosiri lako',
      ),
      subtitle: language.translate(
        'Enter your email and we will send you a reset link.',
        'Weka barua pepe yako tutakutumia kiungo cha kubadilisha nenosiri.',
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthTextField(
              controller: _emailController,
              label: language.translate('Email address', 'Barua pepe'),
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value == null || !value.contains('@')
                  ? language.translate(
                      'Enter a valid email.',
                      'Weka barua pepe sahihi.',
                    )
                  : null,
            ),
            const SizedBox(height: 22),
            PrimaryAuthButton(
              label: language.translate('Send reset link', 'Tuma kiungo'),
              onPressed: () => _sendResetLink(language),
            ),
            const SizedBox(height: 18),
            TextButton.icon(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              ),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: Text(
                language.translate('Back to sign in', 'Rudi kuingia'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
