import 'dart:convert';
import 'dart:io';

import 'package:dart_rest_api/src/api.dart';
import 'package:dart_rest_api/src/domain.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'words_controller.g.dart';

class WordsController {
  final WordRepository wordRepository;

  WordsController(this.wordRepository);

  @Route.get("/")
  Future<Response> getAllWords(Request request) async => Response.ok(
        jsonEncode(await wordRepository.getAllWords()),
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
      );

  @Route.post("/")
  Future<Response> createWord(Request request) async {
    try {
      Map<String, dynamic> json = jsonDecode(
        await request.readAsString(),
      );

      var word = await wordRepository.create(
        json["word"] ?? "",
        json["meaning"] ?? "",
      );

      return Response.ok(
        jsonEncode(
          word.toJson(),
        ),
      );
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on WordValidationException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  @Route.get("/<word|[a-zA-z]+>/")
  Future<Response> read(Request request) async {
    try {
      var word = await wordRepository.read(request.params["word"] ?? "");

      return Response.ok(jsonEncode(word.toJson()));
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on WordNotFoundException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  @Route.put("/<word|[a-zA-z]+>/")
  Future<Response> update(Request request) async {
    try {
      var json = jsonDecode(await request.readAsString());

      var word = await wordRepository.update(
        request.params["word"]!,
        json["meaning"] ?? "",
      );

      return Response.ok(jsonEncode(word.toJson()));
    } on FormatException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    } on WordNotFoundException catch (e) {
      return Response(
        HttpStatus.badRequest,
        body: e.message,
      );
    }
  }

  @Route.delete("/<word|[a-zA-z]+>/")
  Future<Response> delete(Request request) async {
    try {
      await wordRepository.delete(
        request.params["word"]!,
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
      .addHandler(_$WordsControllerRouter(this));
}
