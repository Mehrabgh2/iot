import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:iot/api/services.dart';

void main() {
  group("get Device api", () {
    test("successfuly", () async {
      final mockHTTPClient = MockClient((request) async {
        final response = {
          "code": 200,
          "message": "Appliances have been Fetched successfully",
          "result": {"data": [], "totalElements": 2}
        };
        return Response(jsonEncode(response), 200);
      });
      expect(await getDevices(client: mockHTTPClient), isA<Left>());
    });

    test("Unauthenticated", () async {
      final mockHTTPClient = MockClient((request) async {
        final response = {
          "message": "Unauthenticated",
          "code": 401
        };
        return Response(jsonEncode(response), 401);
      });
      expect(await getDevices(client: mockHTTPClient), isA<Right>());
    });
  });
}
