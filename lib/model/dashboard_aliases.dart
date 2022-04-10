import 'package:iot/model/dashboard.dart';

class DashboardAliases {
  static final DashboardAliases _singleton = DashboardAliases._internal();
  List<DashboardAlias> dashboardAlias = [];
  List<ServerWidget> dashboardWidgets = [];

  factory DashboardAliases() {
    return _singleton;
  }

  DashboardAliases._internal();
}

class DashboardAlias {
  String id;
  String deviceId;
  String name;

  DashboardAlias(
      {required this.id, required this.deviceId, required this.name});
}
