// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      success: json['success'] as bool,
      data: AuthData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
      'timestamp': instance.timestamp,
    };

AuthData _$AuthDataFromJson(Map<String, dynamic> json) => AuthData(
  token: json['token'] as String,
  expiresIn: (json['expires_in'] as num).toInt(),
  refreshToken: json['refresh_token'] as String?,
  user: UserData.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
  'token': instance.token,
  'expires_in': instance.expiresIn,
  'refresh_token': instance.refreshToken,
  'user': instance.user,
};

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: json['id'] as String,
  email: json['email'] as String,
  phoneNumber: json['phone_number'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  type: json['type'] as String,
  status: json['status'] as String,
  avatar: json['avatar'] as String?,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'phone_number': instance.phoneNumber,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'type': instance.type,
  'status': instance.status,
  'avatar': instance.avatar,
  'created_at': instance.createdAt,
};

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      success: json['success'] as bool,
      data: RegisterData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'message': instance.message,
    };

RegisterData _$RegisterDataFromJson(Map<String, dynamic> json) => RegisterData(
  userId: json['user_id'] as String,
  email: json['email'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$RegisterDataToJson(RegisterData instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'message': instance.message,
    };

RefreshTokenResponse _$RefreshTokenResponseFromJson(
  Map<String, dynamic> json,
) => RefreshTokenResponse(
  success: json['success'] as bool,
  data: TokenData.fromJson(json['data'] as Map<String, dynamic>),
  message: json['message'] as String,
);

Map<String, dynamic> _$RefreshTokenResponseToJson(
  RefreshTokenResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

TokenData _$TokenDataFromJson(Map<String, dynamic> json) => TokenData(
  token: json['token'] as String,
  expiresIn: (json['expires_in'] as num).toInt(),
);

Map<String, dynamic> _$TokenDataToJson(TokenData instance) => <String, dynamic>{
  'token': instance.token,
  'expires_in': instance.expiresIn,
};

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  success: json['success'] as bool,
  data: ProfileData.fromJson(json['data'] as Map<String, dynamic>),
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
  id: json['id'] as String,
  email: json['email'] as String,
  phoneNumber: json['phone_number'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  dateOfBirth: json['date_of_birth'] as String?,
  identityNumber: json['identity_number'] as String?,
  city: json['city'] as String?,
  commune: json['commune'] as String?,
  neighborhood: json['neighborhood'] as String?,
  address: json['address'] as String?,
  avatar: json['avatar'] as String?,
  accountStatus: json['account_status'] as String,
  kycStatus: json['kyc_status'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'date_of_birth': instance.dateOfBirth,
      'identity_number': instance.identityNumber,
      'city': instance.city,
      'commune': instance.commune,
      'neighborhood': instance.neighborhood,
      'address': instance.address,
      'avatar': instance.avatar,
      'account_status': instance.accountStatus,
      'kyc_status': instance.kycStatus,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
