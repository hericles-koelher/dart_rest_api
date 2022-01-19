import 'package:dart_rest_api/dart_rest_api.dart';
import 'package:dart_rest_api/src/domain.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  await createDependencies();

  var kiwiContainer = KiwiContainer();

  var apiHandler = Router();

  var authController = AuthController(
    userRepository: kiwiContainer.resolve(),
    tokenService: kiwiContainer.resolve(),
    secret: Environment.secretKey,
  );

  apiHandler.mount(
    "/auth/",
    authController.handler,
  );

  var wordsController = WordsController(
    kiwiContainer.resolve(),
  );

  apiHandler.mount(
    "/words/",
    wordsController.handler,
  );

  var server = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(
        authMiddleware(
          Environment.secretKey,
          kiwiContainer.resolve(),
        ),
      )
      .addHandler(apiHandler);

  await serve(
    server,
    Environment.serverAddress,
    int.parse(Environment.serverPort),
  );

  print("Listening on ${Environment.serverAddress}:${Environment.serverPort}");
}

Future<void> createDependencies() async {
  var mongoDb = Db(Environment.mongoUrl);

  await mongoDb.open();
  print('Connected to our database');

  await createDatabasesIfNotExists(mongoDb);

  var kiwiContainer = KiwiContainer();

  // Registering repositories
  kiwiContainer.registerInstance<IUserRepository>(
    MongoUserRepository(
      mongoDb.collection("users"),
      mongoDb.collection("counters"),
    ),
  );
  kiwiContainer.registerInstance(
    WordRepository(
      mongoDb.collection("words"),
    ),
  );

  // Registering services
  kiwiContainer.registerInstance<ITokenService>(
    await TokenService.createService(
      host: Environment.serverAddress,
      port: 6379,
      secret: Environment.secretKey,
    ),
  );
}

Future<void> createDatabasesIfNotExists(Db mongoDb) async {
  var collectionNames = await mongoDb.getCollectionNames();

  if (!collectionNames.contains("counters")) {
    await mongoDb.createCollection("counters");
    print("Created 'counters' collection");
  }

  if (!collectionNames.contains("users")) {
    await mongoDb.createCollection("users");
    print("Created 'users' collection");
  }

  if (!collectionNames.contains("words")) {
    await mongoDb.createCollection("words");
    print("Created 'words' collection");
  }
}
