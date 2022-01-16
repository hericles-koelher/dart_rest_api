import 'package:dart_rest_api/src/entities.dart';
import 'package:validators/validators.dart';

List<String> validateUserRepresentation(UserRepresentation user) {
  List<String> fieldProblems = [];

  if (user.username.isEmpty) {
    fieldProblems.add("Username can't be empty");
  }

  if (!isEmail(user.email)) {
    fieldProblems.add("Invalid e-mail");
  }

  if (!isLength(user.password, 8)) {
    fieldProblems.add("Password must have at least 8 characters");
  }

  return fieldProblems;
}
