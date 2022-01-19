import '../../domain.dart';

abstract class IUserRepository {
  Future<void> create({
    required String username,
    required String email,
    required String password,
  });

  Future<User> findById(int id);

  Future<User> findByEmail(String email);
}
