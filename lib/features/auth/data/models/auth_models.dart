import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

/// Réponse de connexion
@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  final AuthData data;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'timestamp')
  final String timestamp;

  LoginResponse({
    required this.success,
    required this.data,
    required this.message,
    required this.timestamp,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

/// Données d'authentification
@JsonSerializable()
class AuthData {
  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  @JsonKey(name: 'user')
  final UserData user;

  AuthData({
    required this.token,
    required this.expiresIn,
    this.refreshToken,
    required this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataToJson(this);
}

/// Données utilisateur
@JsonSerializable()
class UserData {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'type')
  final String type; // 'client', 'admin', etc.

  @JsonKey(name: 'status')
  final String status; // 'active', 'inactive', etc.

  @JsonKey(name: 'avatar')
  final String? avatar;

  @JsonKey(name: 'created_at')
  final String createdAt;

  UserData({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.status,
    this.avatar,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

/// Réponse d'enregistrement
@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  final RegisterData data;

  @JsonKey(name: 'message')
  final String message;

  RegisterResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

/// Données d'enregistrement
@JsonSerializable()
class RegisterData {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'message')
  final String message;

  RegisterData({
    required this.userId,
    required this.email,
    required this.message,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}

/// Réponse de refresh token
@JsonSerializable()
class RefreshTokenResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  final TokenData data;

  @JsonKey(name: 'message')
  final String message;

  RefreshTokenResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}

/// Données de token
@JsonSerializable()
class TokenData {
  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  TokenData({
    required this.token,
    required this.expiresIn,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      _$TokenDataFromJson(json);

  Map<String, dynamic> toJson() => _$TokenDataToJson(this);
}

/// Profil utilisateur complet
@JsonSerializable()
class UserProfile {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  final ProfileData data;

  @JsonKey(name: 'timestamp')
  final String timestamp;

  UserProfile({
    required this.success,
    required this.data,
    required this.timestamp,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

/// Données du profil
@JsonSerializable()
class ProfileData {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;

  @JsonKey(name: 'identity_number')
  final String? identityNumber;

  @JsonKey(name: 'city')
  final String? city;

  @JsonKey(name: 'commune')
  final String? commune;

  @JsonKey(name: 'neighborhood')
  final String? neighborhood;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'avatar')
  final String? avatar;

  @JsonKey(name: 'account_status')
  final String accountStatus;

  @JsonKey(name: 'kyc_status')
  final String kycStatus;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  ProfileData({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.identityNumber,
    this.city,
    this.commune,
    this.neighborhood,
    this.address,
    this.avatar,
    required this.accountStatus,
    required this.kycStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}
