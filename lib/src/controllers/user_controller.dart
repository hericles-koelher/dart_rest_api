import 'dart:convert';
import 'dart:io';

import 'package:dart_rest_api/dart_rest_api.dart';
import 'package:dart_rest_api/src/utils/password_utils.dart';
import 'package:dart_rest_api/src/utils/validation_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user_controller.g.dart';

class UserController {
  final DbCollection users;
  final String secretKey;

  UserController(this.users, this.secretKey);

  @Route.post("/register")
  Future<Response> register(Request request) async {
    try {
      // If some field is absent [UnrecognizedKeysException]
      // will be raised.
      var userRepresentation = UserRepresentation.fromJson(
        jsonDecode(await request.readAsString()),
      );

      // Checking if user email was already registered...
      var dbUserJson = await users.findOne(
        where.eq("email", userRepresentation.email),
      );

      if (dbUserJson != null) {
        return Response(
          HttpStatus.badRequest,
          body: "User e-mail already registered",
        );
      }

      // User validation...
      var fieldProblems = validateUserRepresentation(userRepresentation);

      if (fieldProblems.isNotEmpty) {
        String problems = "";

        for (int i = 0; i < fieldProblems.length; i++) {
          problems += "\t${i + 1} - ${fieldProblems[i]}\n";
        }

        return Response(
          HttpStatus.badRequest,
          body: "Some problems were encountered in your request:\n$problems",
        );
      }

      // Saving user in MongoDb
      String salt = generateSalt();

      var user = User(
        username: userRepresentation.username,
        email: userRepresentation.email,
        salt: salt,
        password: hashPassword(userRepresentation.password, salt),
      );

      await users.insertOne(user.toJson());

      return Response.ok("User successfully registered");
    } on UnrecognizedKeysException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  Router get router => _$UserControllerRouter(this);
}
