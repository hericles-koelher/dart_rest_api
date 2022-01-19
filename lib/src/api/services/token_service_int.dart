import '../../api.dart';

abstract class ITokenService {
  Future<TokenPair> createTokenPair(String userId);

  Future<dynamic> getRefreshToken(String tokenId);

  Future<void> removeRefreshToken(String tokenId);

  bool isValidToken(String token);

  String getUserId(String token);

  String getTokenId(String token);
}
