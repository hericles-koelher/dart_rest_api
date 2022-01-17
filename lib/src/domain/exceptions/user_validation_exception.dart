class UserValidationException implements Exception {
  final List<String> fields;
  final List<String> problems;

  UserValidationException(this.fields, this.problems);
}
