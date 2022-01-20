import 'package:mongo_dart/mongo_dart.dart';

import '../../domain.dart';

class MongoUserRepository extends MongoBaseRepository
    implements IUserRepository {
  final DbCollection users;

  MongoUserRepository(
    this.users,
    DbCollection counters,
  ) : super(counters, "userCounter");

  @override
  Future<void> create({
    required String username,
    required String email,
    required String password,
  }) async {
    if (await _isEmailRegistered(email)) {
      throw UserDataValidationException("User email already registered");
    }

    // Validating user entity...
    validateUserCreationData(
      username: username,
      email: email,
      password: password,
    );

    // Creating user entity
    String salt = generateSalt();

    var user = User(
      id: await getNextSequenceValue(),
      username: username,
      email: email,
      salt: salt,
      password: hashPassword(password, salt),
    );

    // Saving user in database
    await users.insertOne(user.toJson());
  }

  @override
  Future<User> findById(int id) async {
    var userJson = await users.findOne(
      where.eq("id", id),
    );

    if (userJson == null) {
      throw UserDataValidationException("User not found");
    }

    return User.fromJson(userJson);
  }

  @override
  Future<User> findByEmail(String email) async {
    var userJson = await users.findOne(
      where.eq("email", email),
    );

    if (userJson == null) {
      throw UserDataValidationException("User not found");
    }

    return User.fromJson(userJson);
  }

  Future<bool> _isEmailRegistered(String email) async {
    var user = await users.findOne(
      where.eq("email", email),
    );

    return user != null;
  }

  @override
  Future<User> update(
    int id, {
    String? username,
    String? email,
    String? password,
  }) async {
    if (!containsNonNullData([username, email, password])) {
      throw UserDataValidationException("User update data not informed");
    }

    validateNonNullUserData(
      username: username,
      email: email,
      password: password,
    );

    var userJson = await users.findOne(
      where.eq("id", id),
    );

    if (userJson == null) {
      throw UserDataValidationException("User not found");
    }

    if (username != null) {
      userJson["username"] = username;
    }

    if (email != null) {
      var userEmail = await users.findOne(
        where.eq("email", email),
      );

      if (userEmail != null) {
        throw UserDataValidationException("Email already in use");
      }

      userJson["email"] = email;
    }

    if (password != null) {
      userJson["password"] = hashPassword(password, userJson["salt"]);
    }

    users.update(where.eq("id", id), userJson);

    return User.fromJson(userJson);
  }

  @override
  Future<void> delete(int id) async {
    await users.deleteOne(
      where.eq("id", id),
    );
  }
}
