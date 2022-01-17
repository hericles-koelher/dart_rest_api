import 'package:dart_rest_api/dart_rest_api.dart';
import 'package:dart_rest_api/src/domain.dart';
import 'package:mongo_dart/mongo_dart.dart';
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

  api.mount(
    "/user/",
    UserController(
      UserRepository(mongoDb.collection("users")),
      Environment.secretKey,
    ).router,
  );

  serve(
    api,
    Environment.serverAddress,
    int.parse(Environment.serverPort),
  );

  print("Listening on ${Environment.serverAddress}:${Environment.serverPort}");
}
