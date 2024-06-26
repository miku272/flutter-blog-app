import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../../../../core/common/entities/user.dart';
import '../../domain/repository/auth_repository.dart';

class UserSignup implements Usecase<User, UserSignupParams> {
  AuthRepository authRepository;

  UserSignup({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(UserSignupParams params) async {
    final response = await authRepository.signUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );

    return response;
  }
}

class UserSignupParams {
  final String name;
  final String email;
  final String password;

  UserSignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
