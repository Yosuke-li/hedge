// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  json['access_token'] as String,
  json['token_type'] as String,
  json['refresh_token'] as String,
  json['expires_in'] as int,
  json['scope'] as String,
  json['OAuth2.SESSION_ID'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresIn,
      'scope': instance.scope,
      'OAuth2.SESSION_ID': instance.oAuth2,
    };
