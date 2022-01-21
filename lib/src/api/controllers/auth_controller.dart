import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../api.dart';
import '../../domain.dart';

part 'auth_controller.g.dart';

class AuthController {
  final IUserRepository userRepository;
  final ITokenService tokenService;
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

      if (json.isEmpty ||
          !json.containsKey("username") ||
          !json.containsKey("email") ||
          !json.containsKey("password")) {
        return Response(
          HttpStatus.badRequest,
          body: "Please inform 'username', 'email' and 'password'",
        );
      }

      await userRepository.create(
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );

      return Response(
        HttpStatus.created,
        body: "User successfully registered",
      );
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on UserDataValidationException catch (e) {
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

      if (json.isEmpty ||
          !json.containsKey("email") ||
          !json.containsKey("password")) {
        return Response(
          HttpStatus.badRequest,
          body: "Empty e-mail and/or password",
        );
      }

      User user = await userRepository.findByEmail(
        json["email"],
      );

      var hashedPassword = hashPassword(
        json["password"],
        user.salt,
      );

      if (hashedPassword != user.password) {
        return Response(
          HttpStatus.badRequest,
          body: "Incorrect email and/or password",
        );
      }

      var tokenPair = await tokenService.createTokenPair(
        user.id.toString(),
      );

      return Response.ok(
        jsonEncode(
          tokenPair.toJson(),
        ),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
      );
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on UserDataValidationException {
      return Response(
        HttpStatus.badRequest,
        body: "Incorrect email and/or password",
      );
    }
  }

  @Route.post("/refreshToken")
  Future<Response> refreshToken(Request request) async {
    try {
      Map<String, dynamic> jsonRefreshToken = jsonDecode(
        await request.readAsString(),
      );

      if (jsonRefreshToken.isEmpty ||
          !jsonRefreshToken.containsKey("refreshToken")) {
        return Response(
          HttpStatus.badRequest,
          body: 'Empty refresh token is not valid',
        );
      }

      var refreshTokenIsValid = tokenService.isValidToken(
        jsonRefreshToken["refreshToken"],
      );

      if (!refreshTokenIsValid) {
        return Response(
          HttpStatus.badRequest,
          body: 'Refresh token is not valid',
        );
      }

      String tokenId = tokenService.getTokenId(
        jsonRefreshToken["refreshToken"],
      );

      var dbToken = await tokenService.getRefreshToken(tokenId);

      if (dbToken == null) {
        return Response(
          HttpStatus.badRequest,
          body: 'Refresh token is not recognised',
        );
      }

      await tokenService.removeRefreshToken(tokenId);

      var newTokenPair = await tokenService.createTokenPair(
        tokenService.getUserId(
          jsonRefreshToken["refreshToken"],
        ),
      );

      return Response.ok(
        jsonEncode(
          newTokenPair.toJson(),
        ),
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
    Map<String, String>? authDetails =
        request.context["authDetails"] as Map<String, String>?;

    if (authDetails == null) {
      return Response.forbidden(
        'Not authorised to perform this operation.',
      );
    }

    await tokenService.removeRefreshToken(
      authDetails["tokenId"]!,
    );

    return Response.ok('Successfully logged out');
  }

  @Route.put("/updateInfo")
  Future<Response> updateInfo(Request request) async {
    Map<String, String>? authDetails =
        request.context["authDetails"] as Map<String, String>?;

    if (authDetails == null) {
      return Response.forbidden(
        'Not authorised to perform this operation.',
      );
    }

    try {
      var json = jsonDecode(
        await request.readAsString(),
      );

      await userRepository.update(
        int.parse(authDetails["userId"]!),
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );

      return Response.ok('User information successfully updated');
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on UserDataValidationException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  @Route.delete("/deleteAccount")
  Future<Response> deleteAccount(Request request) async {
    Map<String, String>? authDetails =
        request.context["authDetails"] as Map<String, String>?;

    if (authDetails == null) {
      return Response.forbidden(
        'Not authorised to perform this operation.',
      );
    }

    await tokenService.removeRefreshToken(
      authDetails["tokenId"]!,
    );

    await userRepository.delete(
      int.parse(authDetails["userId"]!),
    );

    return Response.ok('User successfully deleted');
  }

  Handler get handler => _$AuthControllerRouter(this);
}
