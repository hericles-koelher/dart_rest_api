import 'package:dart_rest_api/src/domain.dart';

abstract class IExpressionRepository {
  Future<Expression> create(String expression, String meaning);

  Future<Expression> read(int expressionId);

  Future<List<Expression>> readAll();

  Future<Expression> update(
    int expressionId, {
    String? expression,
    String? meaning,
  });

  Future<void> delete(int expressionId);
}
