import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../../api.dart';

Middleware authMiddleware(String secret) {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];
      String? token;
      JWT? jwt;

      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        token = authHeader.substring(7);
        jwt = TokenService.verifyToken(token, secret);
      }

      var updatedRequest = request.change(context: {
        'authDetails': jwt,
      });

      return await innerHandler(updatedRequest);
    };
  };
}

Middleware checkAuthMiddleware() {
  return createMiddleware(
    requestHandler: (Request request) {
      if (request.context['authDetails'] == null) {
        return Response.forbidden(
          'Not authorised to perform this action.',
        );
      }
      return null;
    },
  );
}
