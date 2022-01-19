import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../api.dart';
import '../../domain.dart';

part 'expressions_controller.g.dart';

class ExpressionsController {
  final IExpressionRepository expressionRepository;

  ExpressionsController(this.expressionRepository);

  @Route.get("/")
  Future<Response> readAllExpressions(Request request) async => Response.ok(
        jsonEncode(
          await expressionRepository.readAll(),
        ),
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
      );

  @Route.post("/")
  Future<Response> createExpression(Request request) async {
    try {
      Map<String, dynamic> json = jsonDecode(
        await request.readAsString(),
      );

      if (json.isEmpty ||
          !json.containsKey("expression") ||
          !json.containsKey("meaning")) {
        return Response(
          HttpStatus.badRequest,
          body: "Please inform 'expression' and 'meaning'",
        );
      }

      var expression = await expressionRepository.create(
        json["expression"],
        json["meaning"],
      );

      return Response.ok(
        jsonEncode(expression.toJson()),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
      );
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on ExpressionValidationException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  @Route.get("/<expressionId|[0-9]+>/")
  Future<Response> read(Request request) async {
    try {
      var expression = await expressionRepository.read(
        int.parse(request.params["expressionId"]!),
      );

      return Response.ok(
        jsonEncode(expression.toJson()),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
      );
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on ExpressionNotFoundException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  @Route.put("/<expressionId|[0-9]+>/")
  Future<Response> update(Request request) async {
    try {
      var json = jsonDecode(
        await request.readAsString(),
      );

      var expression = await expressionRepository.update(
        int.parse(request.params["expressionId"]!),
        expression: json["expression"],
        meaning: json["meaning"],
      );

      return Response.ok(
        jsonEncode(expression.toJson()),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
      );
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on ExpressionNotFoundException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  @Route.delete("/<expressionId|[0-9]+>/")
  Future<Response> delete(Request request) async {
    try {
      await expressionRepository.delete(
        int.parse(request.params["expressionId"]!),
      );

      return Response(HttpStatus.noContent);
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  Handler get handler => Pipeline()
      .addMiddleware(checkAuthMiddleware())
      .addHandler(_$ExpressionsControllerRouter(this));
}
