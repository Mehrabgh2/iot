import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:iot/api/services.dart';
import 'package:iot/model/dashboard.dart';
import 'package:iot/model/device.dart';
import 'package:iot/model/server_response.dart';

class ApiProvider {
  Future<Either<bool, ServerResponse>> addChartServiceWithAliasProvider(
      {required String aliasId,
      required String chartTitle,
      required List<String> types}) async {
    return addChartWithAliasService(
        chartTitle: chartTitle,
        aliasId: aliasId,
        types: types,
        client: http.Client());
  }

  Future<Either<bool, ServerResponse>> addChartServiceWithoutAliasProvider(
      {required String deviceId,
      required String chartTitle,
      required String aliasName,
      required String uuid,
      required List<String> types}) async {
    return addChartWithoutAliasService(
        deviceId: deviceId,
        chartTitle: chartTitle,
        aliasName: aliasName,
        uuid: uuid,
        types: types,
        client: http.Client());
  }

  Future<Either<Device, ServerResponse>> getDevicesProvider() async {
    return getDevices(client: http.Client());
  }

  Future<Either<Dashboard, ServerResponse>> getDashboardProvider() {
    return getDashboard(client: http.Client());
  }

  Future<String> getSocketTokenProvider() async {
    return getSocketToken(client: http.Client());
  }

  Future<List<String>> getDeviceTypesProvider(
      {required String deviceId}) async {
    return getDeviceTypes(client: http.Client(), deviceId: deviceId);
  }
}
