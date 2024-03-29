import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './core/theme/theme.dart';
import './core/secrets/app_secrets.dart';

import './features/auth/presentation/bloc/auth_bloc.dart';
import './features/auth/domain/usecases/user_signup.dart';
import './features/auth/data/repositories/auth_repository_impl.dart';
import './features/auth/data/datasources/auth_remote_data_source.dart';

import './features/auth/presentation/screens/signin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
    // debug: true,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            userSignup: UserSignup(
              authRepository: AuthRepositoryImpl(
                authRemoteDataSource:
                    AuthRemoteDataSourceImpl(supabaseClient: supabase.client),
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: const SigninScreen(),
    );
  }
}
