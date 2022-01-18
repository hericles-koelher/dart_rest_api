import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_rest_api/dart_rest_api.dart';
import 'package:redis/redis.dart';
import 'package:uuid/uuid.dart';

const _tokenDuration = Duration(minutes: 30);

// Using the rotation strategy to invalidate jwt's.
class TokenService {
  final String secret;
  final String host;
  late final Command _cache;

  static const _prefix = "token";

  TokenService._(
    this.secret,
    this.host,
    Command cache,
  ) : _cache = cache;

  static Future<TokenService> createService({
    required String host,
    required int port,
    required String secret,
  }) async {
    var redisConnection = RedisConnection();

    return TokenService._(
      secret,
      host,
      await redisConnection.connect(host, port),
    );
  }

  Future<TokenPair> createTokenPair(String userId) async {
    final jwtId = Uuid().v4();

    final token = _generateJwt(
      subject: userId,
      jwtId: jwtId,
    );

    final refreshTokenExpiry = Duration(minutes: _tokenDuration.inMinutes * 2);

    final refreshToken = _generateJwt(
      subject: userId,
      jwtId: jwtId,
      expiry: refreshTokenExpiry,
    );

    await _addRefreshTokenToRedis(
      jwtId,
      refreshToken,
      refreshTokenExpiry,
    );

    return TokenPair(token, refreshToken);
  }

  Future<void> _addRefreshTokenToRedis(
    String id,
    String token,
    Duration expiry,
  ) async {
    await _cache.send_object(['SET', '$_prefix:$id', token]);
    await _cache.send_object(['EXPIRE', '$_prefix:$id', expiry.inSeconds]);
  }

  Future<dynamic> getRefreshToken(String id) async {
    return await _cache.get('$_prefix:$id');
  }

  Future<void> removeRefreshToken(String id) async {
    await _cache.send_object(['EXPIRE', '$_prefix:$id', '-1']);
  }

  String _generateJwt({
    required String subject,
    String? jwtId,
    Duration expiry = _tokenDuration,
  }) {
    var now = DateTime.now();

    var jwt = JWT(
      {
        'iat': now.millisecondsSinceEpoch,
      },
      subject: subject,
      issuer: host,
      jwtId: jwtId,
    );

    return jwt.sign(SecretKey(secret), expiresIn: expiry);
  }

  static JWT? verifyToken(String token, String secret) {
    try {
      return JWT.verify(token, SecretKey(secret));
    } on JWTExpiredError {
      return null;
    } on JWTError catch (err) {
      print(err);
      return null;
    }
  }
}
