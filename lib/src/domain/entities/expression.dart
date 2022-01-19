import 'package:json_annotation/json_annotation.dart';

part 'expression.g.dart';

@JsonSerializable()
class Expression {
  final int id;
  final String expression;
  final String meaning;
  final DateTime lastUpdate;

  Expression({
    required this.id,
    required this.expression,
    required this.meaning,
    required this.lastUpdate,
  });

  factory Expression.fromJson(Map<String, dynamic> json) =>
      _$ExpressionFromJson(json);

  Map<String, dynamic> toJson() => _$ExpressionToJson(this);
}
