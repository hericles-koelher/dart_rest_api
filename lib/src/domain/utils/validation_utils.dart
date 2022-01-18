import 'package:validators/validators.dart';

import '../../domain.dart';

void validateUser({
  required String username,
  required String email,
  required String password,
}) {
  List<String> fields = [];
  List<String> problems = [];

  if (username.isEmpty) {
    fields.add("username");
    problems.add("Username can't be empty");
  }

  if (!isEmail(email)) {
    fields.add("username");
    problems.add("Invalid e-mail");
  }

  if (!isLength(password, 8)) {
    fields.add("username");
    problems.add("Password must have at least 8 characters");
  }

  if (fields.isNotEmpty) {
    throw UserValidationException(fields, problems);
  }
}
