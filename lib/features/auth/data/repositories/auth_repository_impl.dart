import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/network/connection_checker.dart';

import '../models/user_model.dart';

import '../../domain/repository/auth_repository.dart';

import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;

  const AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, User>> getCurrentUserData() async {
    try {
      if (!(await connectionChecker.hasConnection)) {
        final session = authRemoteDataSource.currentuserSession;

        if (session == null) {
          return left(Failure(message: 'No internet connection'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }

      final user = await authRemoteDataSource.getCurrentUserData();

      if (user == null) {
        return left(Failure(message: 'User is not logged in'));
      }

      return right(user);
    } on ServerException catch (error) {
      return left(Failure(message: error.message));
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.signupWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteDataSource.signinWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!(await connectionChecker.hasConnection)) {
        left(Failure(message: 'No internet connection'));
      }

      final User user = await fn();

      return right(user);
    } on ServerException catch (error) {
      return left(Failure(message: error.message));
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}
