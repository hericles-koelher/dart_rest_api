import 'dart:convert';
import 'dart:io';

import 'package:dart_rest_api/src/api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../domain.dart';

part 'auth_controller.g.dart';

class AuthController {
  final UserRepository userRepository;
  final TokenService tokenService;

  AuthController({
    required this.userRepository,
    required this.tokenService,
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

      User user = await userRepository.getUserWithEmailAndPassword(
        json["email"],
        json["password"],
      );

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

  Router get router => _$AuthControllerRouter(this);
}
