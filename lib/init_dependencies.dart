import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';

import './core/secrets/app_secrets.dart';
import './core/common/cubits/app_user/app_user_cubit.dart';

import './features/auth/data/datasources/auth_remote_data_source.dart';
import './features/auth/domain/repository/auth_repository.dart';
import './features/auth/data/repositories/auth_repository_impl.dart';
import './features/auth/domain/usecases/user_signup.dart';
import './features/auth/domain/usecases/user_signin.dart';
import './features/auth/domain/usecases/current_user.dart';
import './features/auth/presentation/bloc/auth_bloc.dart';
import './features/blog/data/datasources/blog_remote_data_source.dart';
import './features/blog/domain/repositories/blog_repository.dart';
import './features/blog/data/repositories/blog_repository_impl.dart';
import './features/blog/domain/usecases/upload_blog.dart';
import './features/blog/presentation/bloc/blog_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
    // debug: true,
  );

  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);

  serviceLocator.registerLazySingleton(() => AppUserCubit());
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
      appUserCubit: serviceLocator<AppUserCubit>(),
    ),
  );
}

void _initBlog() {
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(
      supabaseClient: serviceLocator<SupabaseClient>(),
    ),
  );

  serviceLocator.registerFactory<BlogRepository>(
    () => BlogRepositoryImpl(
      blogRemoteDataSource: serviceLocator<BlogRemoteDataSource>(),
    ),
  );

  serviceLocator.registerFactory<UploadBlog>(
    () => UploadBlog(
      blogRepository: serviceLocator<BlogRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => BlogBloc(
      uploadBlog: serviceLocator<UploadBlog>(),
    ),
  );
}
