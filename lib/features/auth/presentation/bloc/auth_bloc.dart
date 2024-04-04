import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/user_signup.dart';
import '../../domain/usecases/user_signin.dart';
import '../../domain/usecases/current_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserSignin _userSignin;
  final CurrentUser _currentUser;

  AuthBloc({
    required UserSignup userSignup,
    required UserSignin userSignin,
    required CurrentUser currentUser,
  })  : _userSignup = userSignup,
        _userSignin = userSignin,
        _currentUser = currentUser,
        super(AuthInitial()) {
    on<AuthSignup>((event, emit) async {
      emit(AuthLoading());

      final res = await _userSignup(
        UserSignupParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) => emit(AuthSuccess(user: user)),
      );
    });

    on<AuthSignin>((event, emit) async {
      emit(AuthLoading());

      final res = await _userSignin(
        UserSigninParams(
          email: event.email,
          password: event.password,
        ),
      );

      res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) => emit(AuthSuccess(user: user)),
      );
    });

    on<AuthIsUserLoggedIn>((event, emit) async {
      final res = await _currentUser(NoParams());

      res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) => emit(AuthSuccess(user: user)),
      );
    });
  }
}
