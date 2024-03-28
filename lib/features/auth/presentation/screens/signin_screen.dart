import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';

import '../widgets/auth_field.dart';
import '../widgets/auth_gradient_button.dart';

import './signup_screen.dart';

class SigninScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SigninScreen(),
      );
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SigninScreen> {
  final GlobalKey _signinKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _signinKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Sign In.',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              AuthField(
                hintText: 'Email',
                controller: _emailController,
              ),
              const SizedBox(height: 15.0),
              AuthField(
                hintText: 'Password',
                isObscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 30.0),
              const AuthGradientButton('Sign In'),
              const SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    SignupScreen.route(),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Sign Up',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
