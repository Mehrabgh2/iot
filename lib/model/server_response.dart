class ServerResponse {
  int code;
  String message;

  ServerResponse(
      {required this.code, required this.message});

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final message = json['message'];
    final result = json['result'] != null ? (json['result']) : null;
    return ServerResponse(
        code: code, message: message);
  }
}
