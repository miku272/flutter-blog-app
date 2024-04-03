import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../repository/auth_repository.dart';

import '../entities/user.dart';

class UserSignin implements Usecase<User, UserSigninParams> {
  final AuthRepository authRepository;

  const UserSignin({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(UserSigninParams params) async {
    return await authRepository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSigninParams {
  final String email;
  final String password;

  const UserSigninParams({
    required this.email,
    required this.password,
  });
}
