// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'words_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$WordsControllerRouter(WordsController service) {
  final router = Router();
  router.add('GET', r'/', service.getAllWords);
  router.add('POST', r'/', service.createWord);
  router.add('GET', r'/<word|[a-zA-z]+>/', service.read);
  router.add('PUT', r'/<word|[a-zA-z]+>/', service.update);
  router.add('DELETE', r'/<word|[a-zA-z]+>/', service.delete);
  return router;
}
