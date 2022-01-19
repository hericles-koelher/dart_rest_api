import 'package:shelf/shelf.dart';

import '../../api.dart';

Middleware authMiddleware(String secret, ITokenService tokenService) {
  return (Handler innerHandler) {
    return (Request request) async {
      var authHeader = request.headers['authorization'];
      String? token;
      String? tokenId;

      if (authHeader != null && authHeader.startsWith('Bearer ')) {
        token = authHeader.substring(7);

        try {
          tokenId = tokenService.getTokenId(token);
        } on TokenValidationException {
          //
        }
      }

      var updatedRequest = request.change(context: {
        'authDetails': tokenId,
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
