import 'package:dart_rest_api/dart_rest_api.dart';
import 'package:dart_rest_api/src/domain.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  var mongoDb = Db(Environment.mongoUrl);

  await mongoDb.open();
  print('Connected to our database');

  var collectionNames = await mongoDb.getCollectionNames();

  if (!collectionNames.contains("users")) {
    await mongoDb.createCollection("users");
    print("Created 'users' collection");
  }

  var api = Router();

  var authController = AuthController(
    userRepository: UserRepository(mongoDb.collection("users")),
    tokenService: await TokenService.createService(
      host: Environment.serverAddress,
      port: 6379,
      secret: Environment.secretKey,
    ),
  );

  api.mount(
    "/auth/",
    authController.router,
  );

  var server = Pipeline()
      .addMiddleware(authMiddleware(Environment.secretKey))
      .addHandler(api);

  serve(
    api,
    Environment.serverAddress,
    int.parse(Environment.serverPort),
  );

  print("Listening on ${Environment.serverAddress}:${Environment.serverPort}");
}
