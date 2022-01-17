import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../api.dart';
import '../../domain.dart';

part 'user_controller.g.dart';

class UserController {
  final UserRepository userRepository;
  final String secretKey;

  UserController(this.userRepository, this.secretKey);

  @Route.post("/register")
  Future<Response> register(Request request) async {
    try {
      // If some field is absent [UnrecognizedKeysException]
      // will be raised.
      var userRepresentation = UserRepresentation.fromJson(
        jsonDecode(await request.readAsString()),
      );

      await userRepository.create(
        username: userRepresentation.username,
        email: userRepresentation.email,
        password: userRepresentation.password,
      );

      return Response.ok("User successfully registered");
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on MissingRequiredKeysException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on UserValidationException catch (e) {
      String problems = "";

      for (int i = 0; i < e.problems.length; i++) {
        problems += "\t${i + 1} - ${e.problems[i]}\n";
      }

      return Response(
        HttpStatus.badRequest,
        body: "Some problems were encountered in your request:\n$problems",
      );
    }
  }

  Router get router => _$UserControllerRouter(this);
}
