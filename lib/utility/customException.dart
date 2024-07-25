class CustomException implements Exception {
  int? status;
  String msg;
  CustomException({this.status, required this.msg});
}
