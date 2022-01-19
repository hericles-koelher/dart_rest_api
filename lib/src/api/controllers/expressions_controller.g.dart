// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expressions_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ExpressionsControllerRouter(ExpressionsController service) {
  final router = Router();
  router.add('GET', r'/', service.readAllExpressions);
  router.add('POST', r'/', service.createExpression);
  router.add('GET', r'/<expressionId|[0-9]+>/', service.read);
  router.add('PUT', r'/<expressionId|[0-9]+>/', service.update);
  router.add('DELETE', r'/<expressionId|[0-9]+>/', service.delete);
  return router;
}
