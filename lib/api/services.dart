import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:iot/model/dashboard.dart';
import 'package:iot/model/dashboard_aliases.dart';
import 'package:iot/model/device.dart';
import 'package:iot/model/server_response.dart';
import 'package:iot/value/values.dart';

String token =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xOTIuMTY4LjEwMC4yMzY6NTAwMFwvYXBpXC92MVwvdGVuYW50LWF1dGhcL2xvZ2luIiwiaWF0IjoxNjQ5NDgzNzc3LCJleHAiOjE2NDk5MTU3NzcsIm5iZiI6MTY0OTQ4Mzc3NywianRpIjoiS1pnTURPN3dKWWJPOHhYeCIsInN1YiI6OCwicHJ2IjoiYjkxMjc5OTc4ZjExYWE3YmM1NjcwNDg3ZmZmMDFlMjI4MjUzZmU0OCJ9.tZz8V7rRTKZHRypSGHoseTRK9qcB7tCt8oShZotWKck";

Future<String> getSocketToken({required http.Client client}) async {
  final response = await client.get(
    Uri.parse('http://192.168.100.236:5000/api/v1/auth/tokens'),
    headers: <String, String>{
      "Authorization": "bearer $token",
      "Accept": "application/json",
      "Content-Type": "application/json"
    },
  );
  return jsonDecode(response.body)['token_2'];
}

Future<List<String>> getDeviceTypes(
    {required http.Client client, required String deviceId}) async {
  final response = await client.get(
    Uri.parse(
        'http://192.168.100.236:5000/api/v1/widget/plugins/telemetry/DEVICE/$deviceId/keys/timeseries'),
    headers: <String, String>{
      "Authorization": "bearer $token",
      "Accept": "application/json",
      "Content-Type": "application/json"
    },
  );
  return List<String>.from(jsonDecode(response.body)['result']);
}

Future<Either<bool, ServerResponse>> addChartWithAliasService(
    {required String aliasId,
    required String chartTitle,
    required List<String> types,
    required http.Client client}) async {
  try {
    final body = addChartReqWithAliasJson(
        chartTitle: chartTitle, aliasId: aliasId, types: types);
    final response = await client.post(
        Uri.parse('http://192.168.100.236:5000/api/v1/widget'),
        headers: <String, String>{
          "Authorization": "bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: body);
    ServerResponse serverResponse =
        ServerResponse.fromJson(jsonDecode(response.body));
    if (serverResponse.code == 200) {
      setDashboard();
      return const Left(true);
    } else {
      return Right(serverResponse);
    }
  } catch (err) {
    return Right(ServerResponse(code: 1, message: err.toString()));
  }
}

Future<Either<bool, ServerResponse>> addChartWithoutAliasService(
    {required String deviceId,
    required String chartTitle,
    required String aliasName,
    required String uuid,
    required List<String> types,
    required http.Client client}) async {
  try {
    final body = addChartReqWithoutAliasJson(
        deviceId: deviceId,
        chartTitle: chartTitle,
        aliasName: aliasName,
        uuid: uuid,
        types: types);
    final response = await client.post(
        Uri.parse('http://192.168.100.236:5000/api/v1/widget'),
        headers: <String, String>{
          "Authorization": "bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: body);
    ServerResponse serverResponse =
        ServerResponse.fromJson(jsonDecode(response.body));
    if (serverResponse.code == 200) {
      setDashboard();
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

Future<Either<bool, String>> setDashboard() async {
  int counter = 1;
  DashboardAliases dd = DashboardAliases();
  try {
    var s = await getDashboard(client: http.Client());
    s.fold(
      (l) {
        dd.dashboardAlias = [];
        dd.dashboardWidgets = [];
        for (final alias in l.result.configuration.entityAliases.aliases) {
          DashboardAlias da = DashboardAlias(
              id: alias.id,
              deviceId: alias.filter.entityList[0],
              name: alias.alias);
          dd.dashboardAlias.add(da);
        }
        for (final widget in l.result.configuration.widgets.serverWidgets) {
          widget.cmdId = counter++;
          dd.dashboardWidgets.add(widget);
        }
        return const Left(true);
      },
      (r) {
        return const Left(false);
      },
    );
  } catch (ex) {
    return Right(ex.toString());
  }
  return const Left(false);
}

Future<Either<Dashboard, ServerResponse>> getDashboard(
    {required http.Client client}) async {
  try {
    final response = await client.get(
        Uri.parse(
            'http://192.168.100.236:5000/api/v1/dashboard/d186af50-b4c3-11ec-aa6d-4b0464327e7a'),
        headers: <String, String>{
          "Authorization": "bearer $token",
          "Accept": "application/json"
        });
    ServerResponse serverResponse =
        ServerResponse.fromJson(jsonDecode(response.body));
    if (serverResponse.code == 200) {
      Dashboard dashboard = Dashboard.fromJson(jsonDecode(response.body));
      return Left(dashboard);
    } else {
      return Right(serverResponse);
    }
  } catch (err) {
    return Right(ServerResponse(code: 1, message: err.toString()));
  }
}
