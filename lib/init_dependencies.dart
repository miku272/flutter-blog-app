import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';

import './core/secrets/app_secrets.dart';

import './features/auth/data/datasources/auth_remote_data_source.dart';
import './features/auth/data/repositories/auth_repository_impl.dart';
import './features/auth/domain/repository/auth_repository.dart';
import './features/auth/domain/usecases/user_signup.dart';
import './features/auth/domain/usecases/user_signin.dart';
import './features/auth/domain/usecases/current_user.dart';

import './features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
    // debug: true,
  );

  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);

  _initAuth();
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator<SupabaseClient>(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    ),
  );

  serviceLocator.registerFactory<UserSignup>(
    () => UserSignup(
      authRepository: serviceLocator<AuthRepository>(),
    ),
  );

  serviceLocator.registerFactory<UserSignin>(
    () => UserSignin(
      authRepository: serviceLocator<AuthRepository>(),
    ),
  );

  serviceLocator.registerFactory<CurrentUser>(
    () => CurrentUser(
      authRepository: serviceLocator<AuthRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      userSignup: serviceLocator<UserSignup>(),
      userSignin: serviceLocator<UserSignin>(),
      currentUser: serviceLocator<CurrentUser>(),
    ),
  );
}
