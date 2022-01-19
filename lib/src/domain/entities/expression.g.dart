// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expression.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expression _$ExpressionFromJson(Map<String, dynamic> json) => Expression(
      id: json['id'] as int,
      expression: json['expression'] as String,
      meaning: json['meaning'] as String,
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );

Map<String, dynamic> _$ExpressionToJson(Expression instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expression': instance.expression,
      'meaning': instance.meaning,
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };
