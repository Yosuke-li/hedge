import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';


@JsonSerializable()
class User extends Object {

  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'token_type')
  String tokenType;

  @JsonKey(name: 'refresh_token')
  String refreshToken;

  @JsonKey(name: 'expires_in')
  int expiresIn;

  @JsonKey(name: 'scope')
  String scope;

  @JsonKey(name: 'OAuth2.SESSION_ID')
  String oAuth2;

  User(this.accessToken,this.tokenType,this.refreshToken,this.expiresIn,this.scope,this.oAuth2,);

  factory User.fromJson(Map<String, dynamic> srcJson) => _$UserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}


