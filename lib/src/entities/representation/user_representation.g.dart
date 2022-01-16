// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_representation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRepresentation _$UserRepresentationFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['username', 'email', 'password'],
  );
  return UserRepresentation(
    username: json['username'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$UserRepresentationToJson(UserRepresentation instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
    };
