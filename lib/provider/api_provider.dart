import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:iot/api/services.dart';
import 'package:iot/model/device.dart';
import 'package:iot/model/server_response.dart';

class ApiProvider {
  Future<Either<bool, ServerResponse>> addChartServiceProvider(
      {required String deviceId, required String chartTitle}) async {
    return addChartService(
        deviceId: deviceId, chartTitle: chartTitle, client: http.Client());
  }

  Future<Either<Device, ServerResponse>> getDevicesProvider() async {
    return getDevices(client: http.Client());
  }
}
