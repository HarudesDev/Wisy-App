enum GenericExceptionTypes {
  unknown;
}

class GenericException implements Exception {
  Object? error;
  StackTrace stack = StackTrace.current;
  String message;
  GenericExceptionTypes type;
  GenericException({this.error, required this.message, required this.type});
}
