import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';

import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signinWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  const AuthRemoteDataSourceImpl({
    required this.supabaseClient,
  });

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

      return UserModel.fromJson(response.user!.toJson());
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future<UserModel> signinWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signinWithEmailAndPassword
    throw UnimplementedError();
  }
}
