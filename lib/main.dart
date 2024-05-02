import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './init_dependencies.dart';

import './core/theme/theme.dart';
import './core/common/cubits/app_user/app_user_cubit.dart';

import './features/auth/presentation/bloc/auth_bloc.dart';

import './features/auth/presentation/screens/signin_screen.dart';
import './features/blog/presentation/screens/blog_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(AuthIsUserSignedin());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(selector: (state) {
        return state is AppUserSignedin;
      }, builder: (context, isLoggedIn) {
        if (isLoggedIn) {
          return const BlogScreen();
        }
        return const SigninScreen();
      }),
    );
  }
}
