import 'package:mongo_dart/mongo_dart.dart';

import '../../domain.dart';

class UserRepository {
  final DbCollection users;

  UserRepository(this.users);

  Future<bool> isEmailRegistered(String email) async {
    var user = await users.findOne(
      where.eq("email", email),
    );

    return user != null;
  }

  Future<void> create({
    required String username,
    required String email,
    required String password,
  }) async {
    if (await isEmailRegistered(email)) {
      throw UserValidationException(
        ["email"],
        ["User email already registered"],
      );
    }

    // Saving user in MongoDb
    String salt = generateSalt();

    var user = User(
      username: username,
      email: email,
      salt: salt,
      password: hashPassword(password, salt),
    );

    // User validation...
    validateUser(user);

    await users.insertOne(user.toJson());
  }
}
