part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppUserSignedin extends AppUserState {
  final User user;

  AppUserSignedin({
    required this.user,
  });
}
