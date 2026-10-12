import '../../domain/entities/auth_tokens_entity.dart';

class LoginResponseModel extends AuthTokensEntity {
  const LoginResponseModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}