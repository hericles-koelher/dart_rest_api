import 'package:validators/validators.dart';

import '../../domain.dart';

void validateUserCreationData({
  required String username,
  required String email,
  required String password,
}) {
  bool flag = false;
  String message = "Errors were found during data validation:\n";

  if (username.isEmpty) {
    flag = true;
    message += "\tUsername can't be empty\n";
  }

  if (!isEmail(email)) {
    flag = true;
    message += "\tInvalid e-mail\n";
  }

  if (!isLength(password, 8)) {
    flag = true;
    message += "\tPassword must have at least 8 characters\n";
  }

  if (flag) {
    throw UserValidationException(message);
  }
}

void validateExpression(String expression, String meaning) {
  if (expression.isEmpty) {
    throw ExpressionValidationException("Empty expression isn't valid");
  }

  if (meaning.isEmpty) {
    throw ExpressionValidationException("Empty meaning isn't valid");
  }
}
