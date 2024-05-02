import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/common/cubits/app_user/app_user_cubit.dart';

import '../../domain/usecases/user_signup.dart';
import '../../domain/usecases/user_signin.dart';
import '../../domain/usecases/current_user.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignup;
  final UserSignin _userSignin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignup userSignup,
    required UserSignin userSignin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignup = userSignup,
        _userSignin = userSignin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
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
        (user) => _emitAuthSuccess(user, emit),
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
        (user) => _emitAuthSuccess(user, emit),
      );
    });

    on<AuthIsUserSignedin>((event, emit) async {
      final res = await _currentUser(NoParams());

      res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) => _emitAuthSuccess(user, emit),
      );
    });
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
