import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_rest_api/src/api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../domain.dart';

part 'auth_controller.g.dart';

class AuthController {
  final UserRepository userRepository;
  final TokenService tokenService;
  final String secret;

  AuthController({
    required this.userRepository,
    required this.tokenService,
    required this.secret,
  });

  @Route.post("/register")
  Future<Response> register(Request request) async {
    try {
      Map<String, dynamic> json = jsonDecode(
        await request.readAsString(),
      );

      await userRepository.create(
        username: json["username"] ?? "",
        email: json["email"] ?? "",
        password: json["password"] ?? "",
      );

      return Response.ok("User successfully registered");
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on UserValidationException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  @Route.post("/login")
  Future<Response> login(Request request) async {
    try {
      Map<String, dynamic> json = jsonDecode(
        await request.readAsString(),
      );

      User user = await userRepository.findByEmail(
        json["email"],
      );

      var hashedPassword = hashPassword(
        json["password"],
        user.salt,
      );

      if (hashedPassword != user.password) {
        throw UserValidationException("Incorrect password");
      }

      var tokenPair = await tokenService.createTokenPair(user.email);

      return Response.ok(
        jsonEncode(tokenPair.toJson()),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
      );
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on UserValidationException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  @Route.post("/refreshToken")
  Future<Response> refreshToken(Request request) async {
    try {
      var jsonToken = jsonDecode(
        await request.readAsString(),
      );

      var token = TokenService.verifyToken(
        jsonToken["refreshToken"] ?? "",
        secret,
      );

      if (token == null) {
        return Response(
          HttpStatus.badRequest,
          body: 'Refresh token is not recognised.',
        );
      }

      await tokenService.removeRefreshToken(token.jwtId!);

      var newTokenPair = await tokenService.createTokenPair(token.subject!);

      return Response.ok(
        jsonEncode(newTokenPair.toJson()),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
      );
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  @Route.post("/logout")
  Future<Response> logout(Request request) async {
    JWT? token = request.context['authDetails'] as JWT?;

    if (token == null) {
      return Response.forbidden(
        'Not authorised to perform this operation.',
      );
    }

    await tokenService.removeRefreshToken(token.jwtId!);

    return Response.ok('Successfully logged out');
  }

  Handler get handler => _$AuthControllerRouter(this);
}
