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

  var expressionsController = ExpressionsController(
    kiwiContainer.resolve(),
  );

  apiHandler.mount(
    "/expressions/",
    expressionsController.handler,
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
    Environment.serverPort,
  );

  print("Listening on ${Environment.serverAddress}:${Environment.serverPort}");
}

Future<void> createDependencies() async {
  print("Creating dependencies");
  var mongoDb = Db(Environment.mongoUrl);

  await mongoDb.open();
  print('Connected to our database');

  await createCollectionsIfNotExists(mongoDb);

  var kiwiContainer = KiwiContainer();

  // Registering repositories
  kiwiContainer.registerInstance<IUserRepository>(
    MongoUserRepository(
      mongoDb.collection("users"),
      mongoDb.collection("counters"),
    ),
  );
  kiwiContainer.registerInstance<IExpressionRepository>(
    MongoExpressionRepository(
      mongoDb.collection("expressions"),
      mongoDb.collection("counters"),
    ),
  );

  // Registering services
  kiwiContainer.registerInstance<ITokenService>(
    await TokenService.createService(
      host: Environment.redisHost,
      port: Environment.redisPort,
      secret: Environment.secretKey,
    ),
  );
}

Future<void> createCollectionsIfNotExists(Db mongoDb) async {
  var collectionNames = await mongoDb.getCollectionNames();

  if (!collectionNames.contains("counters")) {
    await mongoDb.createCollection("counters");
    print("Created 'counters' collection");
  }

  if (!collectionNames.contains("users")) {
    await mongoDb.createCollection("users");
    print("Created 'users' collection");
  }

  if (!collectionNames.contains("expressions")) {
    await mongoDb.createCollection("expressions");
    print("Created 'expressions' collection");
  }
}
