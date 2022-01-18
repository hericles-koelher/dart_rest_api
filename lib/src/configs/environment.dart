import 'package:envify/envify.dart';

part 'environment.g.dart';

@Envify()
abstract class Environment {
  static const secretKey = _Environment.secretKey;
  static const mongoUrl = _Environment.mongoUrl;
  static const serverAddress = _Environment.serverAddress;
  static const serverPort = _Environment.serverPort;
}
