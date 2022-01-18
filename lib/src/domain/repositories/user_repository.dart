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
      throw UserValidationException("User email already registered");
    }

    // Validating user entity...
    validateUserRegisterFields(
      username: username,
      email: email,
      password: password,
    );

    // Creating user entity
    String salt = generateSalt();

    var user = User(
      username: username,
      email: email,
      salt: salt,
      password: hashPassword(password, salt),
    );

    // Saving user in database
    await users.insertOne(user.toJson());
  }

  Future<User> getUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    var userJson = await users.findOne(
      where.eq("email", email),
    );

    if (userJson == null) {
      throw UserValidationException("Incorrect email and/or password");
    }

    var possibleUser = User.fromJson(userJson);

    var hashedUserJsonPassword = hashPassword(password, possibleUser.salt);

    if (hashedUserJsonPassword != possibleUser.password) {
      throw UserValidationException("Incorrect email and/or password");
    }

    return possibleUser;
  }
}
