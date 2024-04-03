import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';

import './core/secrets/app_secrets.dart';

import './features/auth/data/datasources/auth_remote_data_source.dart';
import './features/auth/data/repositories/auth_repository_impl.dart';
import './features/auth/domain/repository/auth_repository.dart';
import './features/auth/domain/usecases/user_signup.dart';
import './features/auth/domain/usecases/user_signin.dart';

import './features/auth/presentation/bloc/auth_bloc.dart';

final serviceocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
    // debug: true,
  );

  serviceocator.registerLazySingleton<SupabaseClient>(() => supabase.client);

  _initAuth();
}

void _initAuth() {
  serviceocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceocator<SupabaseClient>(),
    ),
  );

  serviceocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: serviceocator<AuthRemoteDataSource>(),
    ),
  );

  serviceocator.registerFactory<UserSignup>(
    () => UserSignup(
      authRepository: serviceocator<AuthRepository>(),
    ),
  );

  serviceocator.registerFactory<UserSignin>(
    () => UserSignin(
      authRepository: serviceocator<AuthRepository>(),
    ),
  );

  serviceocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      userSignup: serviceocator<UserSignup>(),
      userSignin: serviceocator<UserSignin>(),
    ),
  );
}
