import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class UserSignup implements Usecase<String, UserSignupParams> {
  @override
  Future<Either<Failure, String>> call(params) {
    // TODO: implement call
    throw UnimplementedError();
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
