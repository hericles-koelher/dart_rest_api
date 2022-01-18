// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['word', 'meaning', 'lastUpdate'],
  );
  return Word(
    word: json['word'] as String,
    meaning: json['meaning'] as String,
    lastUpdate: DateTime.parse(json['lastUpdate'] as String),
  );
}

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'word': instance.word,
      'meaning': instance.meaning,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };
