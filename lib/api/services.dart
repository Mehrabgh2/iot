import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:iot/model/device.dart';
import 'package:iot/model/server_response.dart';
import 'package:iot/value/values.dart';

String token =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xOTIuMTY4LjEwMC4yMzY6NTAwMFwvYXBpXC92MVwvdGVuYW50LWF1dGhcL2xvZ2luIiwiaWF0IjoxNjQ5MDUwMDY2LCJleHAiOjE2NDk0ODIwNjYsIm5iZiI6MTY0OTA1MDA2NiwianRpIjoiMWNKM29GZ09iZTJvb1d0ViIsInN1YiI6OCwicHJ2IjoiYjkxMjc5OTc4ZjExYWE3YmM1NjcwNDg3ZmZmMDFlMjI4MjUzZmU0OCJ9.w0xZ3FiVnn2fLhkvKUER3Xpe4HBT-sscz6UAmw9i5y4";

Future<Either<bool, ServerResponse>> addChartService(
    {required String deviceId,
    required String chartTitle,
    required http.Client client}) async {
  try {
    final response =
        await client.post(Uri.parse('http://192.168.100.236:5000/api/v1/widget'),
            headers: <String, String>{
              "Authorization": "bearer $token",
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            body: addChartReqJson(deviceId: deviceId, chartTitle: chartTitle));
    ServerResponse serverResponse =
        ServerResponse.fromJson(jsonDecode(response.body));
    if (serverResponse.code == 200) {
      return const Left(true);
    } else {
      return Right(serverResponse);
    }
  } catch (err) {
    return Right(ServerResponse(code: 1, message: err.toString()));
  }
}

Future<Either<Device, ServerResponse>> getDevices(
    {required http.Client client}) async {
  try {
    final response = await client.get(
        Uri.parse('http://192.168.100.236:5000/api/v1/devices'),
        headers: <String, String>{
          "Authorization": "bearer $token",
          "Accept": "application/json"
        });
    ServerResponse serverResponse =
        ServerResponse.fromJson(jsonDecode(response.body));
    if (serverResponse.code == 200) {
      return Left(Device.fromJson(jsonDecode(response.body)));
    } else {
      return Right(serverResponse);
    }
  } catch (err) {
    return Right(ServerResponse(code: 1, message: err.toString()));
  }
}