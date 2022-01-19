import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(required: true)
  final int id;

  @JsonKey(required: true)
  final String username;

  @JsonKey(required: true)
  final String email;

  @JsonKey(required: true)
  final String password;

  @JsonKey(required: true)
  final String salt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.salt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
