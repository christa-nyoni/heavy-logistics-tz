import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageProvider>();
    return AuthScaffold(
      title: language.translate('Create your account', 'Fungua akaunti yako'),
      subtitle: language.translate(
        'Start moving freight with a trusted network.',
        'Anza kusafirisha mizigo kupitia mtandao unaoaminika.',
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthTextField(
              controller: _nameController,
              label: language.translate('Full name', 'Jina kamili'),
              icon: Icons.person_outline,
              validator: (value) => value == null || value.trim().isEmpty
                  ? language.translate('Enter your name.', 'Weka jina lako.')
                  : null,
            ),
            const SizedBox(height: 14),
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
            const SizedBox(height: 14),
            AuthTextField(
              controller: _passwordController,
              label: language.translate('Password', 'Nenosiri'),
              icon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
              validator: (value) => value == null || value.length < 6
                  ? language.translate(
                      'Use at least 6 characters.',
                      'Tumia angalau herufi 6.',
                    )
                  : null,
            ),
            const SizedBox(height: 22),
            PrimaryAuthButton(
              label: language.translate('Create account', 'Fungua akaunti'),
              onPressed: () {
                if (_formKey.currentState!.validate()) Navigator.pop(context);
              },
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              ),
              child: Text(
                language.translate(
                  'Already have an account? Sign in',
                  'Una akaunti? Ingia',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
