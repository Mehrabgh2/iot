import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:iot/api/services.dart';

void main() {
  group("Add chart api", () {
    test("Successful", () async {
      final mockHTTPClient = MockClient((request) async {
        final response = {"message": "Operation successful", "code": 200};
        return Response(jsonEncode(response), 200);
      });
      expect(
          await addChartWithoutAliasService(
              deviceId: "",
              chartTitle: "",
              aliasName: "",
              uuid: "",
              types: [],
              client: mockHTTPClient),
          isA<Left>());
    });

    test("Unauthenticated", () async {
      final mockHTTPClient = MockClient((request) async {
        final response = {"message": "Unauthenticated", "code": 401};
        return Response(jsonEncode(response), 401);
      });
      expect(
          await addChartWithoutAliasService(
              deviceId: "",
              chartTitle: "",
              aliasName: "",
              uuid: "",
              types: [],
              client: mockHTTPClient),
          isA<Right>());
    });

    test("Validation failed", () async {
      final mockHTTPClient = MockClient((request) async {
        final response = {
          "message": "Validation failed, Please fix validation errors",
          "code": 422,
          "result": []
        };
        return Response(jsonEncode(response), 422);
      });
      expect(
          await addChartWithoutAliasService(
              deviceId: "",
              chartTitle: "",
              aliasName: "",
              uuid: "",
              types: [],
              client: mockHTTPClient),
          isA<Right>());
    });
  });
}
