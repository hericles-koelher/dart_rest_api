import 'package:validators/validators.dart';

import '../../domain.dart';

void validateUserRegisterFields({
  required String username,
  required String email,
  required String password,
}) {
  bool flag = false;
  String message = "Errors were found during field validation:\n";
  String? fieldStringAux;

  if ((fieldStringAux = _usernameVal(username)) != null) {
    flag = true;
    message += "\t$fieldStringAux\n";
  }

  if ((fieldStringAux = _emailVal(email)) != null) {
    flag = true;
    message += "\t$fieldStringAux\n";
  }

  if ((fieldStringAux = _passwordVal(password)) != null) {
    flag = true;
    message += "\t$fieldStringAux\n";
  }

  if (flag) {
    throw UserValidationException(message);
  }
}

void validateUserLoginFields({
  required String email,
  required String password,
}) {
  bool flag = false;
  String message = "Errors were found during field validation:\n";
  String? fieldStringAux;

  if ((fieldStringAux = _emailVal(email)) != null) {
    flag = true;
    message += "\t$fieldStringAux\n";
  }

  if ((fieldStringAux = _passwordVal(password)) != null) {
    flag = true;
    message += "\t$fieldStringAux\n";
  }

  if (flag) {
    throw UserValidationException(message);
  }
}

String? _usernameVal(String username) =>
    username.isEmpty ? "Username can't be empty" : null;

String? _emailVal(String email) => !isEmail(email) ? "Invalid e-mail" : null;

String? _passwordVal(String password) =>
    !isLength(password, 8) ? "Password must have at least 8 characters" : null;
