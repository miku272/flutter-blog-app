import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/common/widgets/loader.dart';

import '../bloc/auth_bloc.dart';

import '../widgets/auth_field.dart';
import '../widgets/auth_gradient_button.dart';

import '../../../blog/presentation/screens/blog_screen.dart';

import './signup_screen.dart';

class SigninScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SigninScreen(),
      );

  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _signinKey = GlobalKey<FormState>();

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
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackbar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                BlogScreen.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }

            return Form(
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
                  AuthGradientButton(
                    'Sign In',
                    onTap: () {
                      if (_signinKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthSignin(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            ));
                      }
                    },
                  ),
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
            );
          },
        ),
      ),
    );
  }
}
