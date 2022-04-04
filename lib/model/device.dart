class Device {
  int code;
  String message;
  Result result;

  Device({
    required this.code,
    required this.message,
    required this.result,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final message = json['message'];
    final result = Result.fromJson(json['result']);
    return Device(code: code, message: message, result: result);
  }
}

class Result {
  List<Data> data;
  int totalElements;

  Result({required this.data, required this.totalElements});

  factory Result.fromJson(Map<String, dynamic> json) {
    List<Data> data = [];
    json['data'].forEach((v) {
      data.add(Data.fromJson(v));
    });
    final totalElements = json['totalElements'];
    return Result(data: data, totalElements: totalElements);
  }
}

class Data {
  String id;
  String name;

  Data({required this.id, required this.name});

  factory Data.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    return Data(id: id, name: name);
  }

  bool operator ==(dynamic other) =>
      other != null && other is Data && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}
