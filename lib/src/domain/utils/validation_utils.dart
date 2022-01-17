import 'package:validators/validators.dart';

import '../../domain.dart';

void validateUser(User user) {
  List<String> fields = [];
  List<String> problems = [];

  if (user.username.isEmpty) {
    fields.add("username");
    problems.add("Username can't be empty");
  }

  if (!isEmail(user.email)) {
    fields.add("username");
    problems.add("Invalid e-mail");
  }

  if (!isLength(user.password, 8)) {
    fields.add("username");
    problems.add("Password must have at least 8 characters");
  }

  if (fields.isNotEmpty) {
    throw UserValidationException(fields, problems);
  }
}
