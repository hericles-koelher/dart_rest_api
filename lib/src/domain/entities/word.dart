import 'package:json_annotation/json_annotation.dart';

part 'word.g.dart';

@JsonSerializable()
class Word {
  @JsonKey(required: true)
  final String word;

  @JsonKey(required: true)
  final String meaning;

  @JsonKey(required: true)
  final DateTime lastUpdate;

  Word({
    required this.word,
    required this.meaning,
    required this.lastUpdate,
  });

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  Map<String, dynamic> toJson() => _$WordToJson(this);
}
