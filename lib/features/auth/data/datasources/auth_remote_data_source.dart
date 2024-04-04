import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';

import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentuserSession;

  Future<UserModel> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signinWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  const AuthRemoteDataSourceImpl({
    required this.supabaseClient,
  });

  @override
  Session? get currentuserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'avatar_url': null,
        },
      );

      if (response.user == null) {
        throw ServerException(message: 'Failed to sign up');
      }

      return UserModel.fromJson(response.user!.toJson()).copyWith(
        email: currentuserSession!.user.email,
      );
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future<UserModel> signinWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException(message: 'Failed to sign in');
      }

      return UserModel.fromJson(response.user!.toJson()).copyWith(
        email: currentuserSession!.user.email,
      );
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentuserSession != null) {
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentuserSession!.user.id,
            );

        return UserModel.fromJson(userData.first).copyWith(
          email: currentuserSession!.user.email,
        );
      }

      return null;
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }
}
