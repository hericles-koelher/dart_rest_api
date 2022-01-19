import 'package:envify/envify.dart';

part 'environment.g.dart';

@Envify()
abstract class Environment {
  static const String secretKey = _Environment.secretKey;
  static const String mongoUrl = _Environment.mongoUrl;
  static const String serverAddress = _Environment.serverAddress;
  static const int serverPort = _Environment.serverPort;
  static const String redisHost = _Environment.redisHost;
  static const int redisPort = _Environment.redisPort;
}
