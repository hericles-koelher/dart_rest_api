import 'package:json_annotation/json_annotation.dart';

part 'user_representation.g.dart';

@JsonSerializable()
class UserRepresentation {
  @JsonKey(required: true)
  final String username;

  @JsonKey(required: true)
  final String email;

  @JsonKey(required: true)
  final String password;

  UserRepresentation({
    required this.username,
    required this.email,
    required this.password,
  });

  factory UserRepresentation.fromJson(Map<String, dynamic> json) =>
      _$UserRepresentationFromJson(json);

  Map<String, dynamic> toJson() => _$UserRepresentationToJson(this);
}
