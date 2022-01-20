// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AuthControllerRouter(AuthController service) {
  final router = Router();
  router.add('POST', r'/register', service.register);
  router.add('POST', r'/login', service.login);
  router.add('POST', r'/refreshToken', service.refreshToken);
  router.add('POST', r'/logout', service.logout);
  router.add('PUT', r'/updateInfo', service.updateInfo);
  router.add('DELETE', r'/deleteAccount', service.deleteAccount);
  return router;
}
