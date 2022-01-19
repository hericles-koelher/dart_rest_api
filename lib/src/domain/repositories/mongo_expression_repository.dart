import 'package:mongo_dart/mongo_dart.dart';

import '../../domain.dart';

class MongoExpressionRepository extends MongoBaseRepository
    implements IExpressionRepository {
  final DbCollection expressions;

  MongoExpressionRepository(this.expressions, DbCollection counters)
      : super(counters, "expressionCounter");

  @override
  Future<Expression> create(String expression, String meaning) async {
    validateExpression(expression, meaning);

    expression = expression.toLowerCase().trim();

    var expressionEntity = Expression(
      id: await getNextSequenceValue(),
      expression: expression,
      meaning: meaning,
      lastUpdate: DateTime.now(),
    );

    await expressions.insertOne(
      expressionEntity.toJson(),
    );

    return expressionEntity;
  }

  @override
  Future<Expression> read(int expressionId) async {
    var expressionJson = await expressions.findOne(
      where.eq("id", expressionId),
    );

    if (expressionJson == null) {
      throw ExpressionNotFoundException("Expression not found in our database");
    }

    return Expression.fromJson(expressionJson);
  }

  @override
  Future<Expression> update(
    int expressionId, {
    String? expression,
    String? meaning,
  }) async {
    var updatedExpressionJson = await expressions.findOne(
      where.eq("id", expressionId),
    );

    if (updatedExpressionJson == null) {
      throw ExpressionNotFoundException("Expression not found in our database");
    }

    bool updateFlag = false;

    if (expression != null && expression.isNotEmpty) {
      await expressions.updateOne(
        where.eq("id", expressionId),
        modify.set("expression", expression),
      );

      updateFlag = true;
    }

    if (meaning != null && meaning.isNotEmpty) {
      await expressions.updateOne(
        where.eq("id", expressionId),
        modify.set("meaning", meaning),
      );

      updateFlag = true;
    }

    if (updateFlag) {
      await expressions.updateOne(
        where.eq("id", expressionId),
        modify.set("lastUpdate", DateTime.now().toString()),
      );
    }

    updatedExpressionJson = await expressions.findOne(
      where.eq("id", expressionId),
    );

    return Expression.fromJson(updatedExpressionJson!);
  }

  @override
  Future<void> delete(int expressionId) async {
    await expressions.deleteOne(
      where.eq("id", expressionId),
    );
  }

  @override
  Future<List<Expression>> readAll() async =>
      (await expressions.find().toList())
          .map((expressionJson) => Expression.fromJson(expressionJson))
          .toList();
}
