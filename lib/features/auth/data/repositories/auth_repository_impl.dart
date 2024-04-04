import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';

import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';

import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  const AuthRepositoryImpl({
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, User>> getCurrentUserData() async {
    try {
      final user = await authRemoteDataSource.getCurrentUserData();

      if (user == null) {
        return left(Failure(message: 'User is not logged in'));
      }

      return right(user);
    } on sb.AuthException catch (error) {
      return left(Failure(message: error.message));
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
      final User user = await fn();

      return right(user);
    } on sb.AuthException catch (error) {
      return left(Failure(message: error.message));
    } on ServerException catch (error) {
      return left(Failure(message: error.message));
    } catch (error) {
      return left(Failure(message: error.toString()));
    }
  }
}
