import 'dart:convert';

import 'package:iot/model/dashboard.dart';
import 'package:iot/model/dashboard_aliases.dart';

addChartReqWithAliasJson(
    {required String aliasId,
    required String chartTitle,
    required List<String> types}) {
  List<Map> aliases = [];
  List<Map> widgets = [];
  DashboardAliases da = DashboardAliases();
  for (final alias in da.dashboardAlias) {
    aliases.add({
      "id": alias.id,
      "alias": alias.name,
      "filter": {
        "type": "entityList",
        "resolveMultiple": true,
        "entityType": "DEVICE",
        "entityList": [alias.deviceId]
      }
    });
  }
  for (final widget in da.dashboardWidgets) {
    widgets.add(createWidgetfromjson(widget));
  }
  widgets.add({
    "config": {
      "datasources": [
        {
          "type": "entity",
          "entityAliasId": aliasId,
          "dataKeys": [
            {
              "name": types[0],
              "type": "timeseries",
              "label": types[0],
              "color": "#70c6bb",
              "settings": {},
              "_hash": 0.7282710489093589,
              "funcBody":
                  "var value = prevValue + Math.random() * 50 - 25;\nif (value < -100) {\n\tvalue = -100;\n} else if (value > 100) {\n\tvalue = 100;\n}\nreturn value;"
            },
            {
              "name": types[1],
              "type": "timeseries",
              "label": types[1],
              "color": "#7aa6bb",
              "settings": {},
              "_hash": 0.7282710489093589,
              "funcBody":
                  "var value = prevValue + Math.random() * 50 - 25;\nif (value < -100) {\n\tvalue = -100;\n} else if (value > 100) {\n\tvalue = 100;\n}\nreturn value;"
            }
          ]
        }
      ],
      "title": chartTitle,
      "useDashboardTimewindow": true,
      "settings": {
        "shadowSize": 4,
        "fontColor": "#545454",
        "fontSize": 10,
        "xaxis": {"showLabels": true, "color": "#545454"},
        "yaxis": {"showLabels": true, "color": "#545454"},
        "grid": {
          "color": "#545454",
          "tickColor": "#DDDDDD",
          "verticalLines": true,
          "horizontalLines": true,
          "outlineWidth": 1
        },
        "legend": {
          "show": true,
          "position": "nw",
          "backgroundColor": "#f0f0f0",
          "backgroundOpacity": 0.85,
          "labelBoxBorderColor": "rgba(1, 1, 1, 0.45)"
        },
        "decimals": 1,
        "stack": false,
        "tooltipIndividual": false
      },
      "timewindow": {
        "realtime": {"timewindowMs": 60000}
      }
    },
    "bundleAlias": "charts",
    "typeAlias": "timeseries_bars_flot",
    "_typeAlias": "timeseries_bars_flot",
    "type": "timeseries",
    "isSystemType": "true"
  });
  final jsonn = json.encode({
    "dashboardId": "d186af50-b4c3-11ec-aa6d-4b0464327e7a",
    "widgets": widgets,
    "entityAliases": aliases
  });
  return jsonn;
}

addChartReqWithoutAliasJson(
    {required String deviceId,
    required String chartTitle,
    required String aliasName,
    required String uuid,
    required List<String> types}) {
  List<Map> aliases = [];
  List<Map> widgets = [];
  DashboardAliases da = DashboardAliases();
  for (final alias in da.dashboardAlias) {
    aliases.add({
      "id": alias.id,
      "alias": alias.name,
      "filter": {
        "type": "entityList",
        "resolveMultiple": true,
        "entityType": "DEVICE",
        "entityList": [alias.deviceId]
      }
    });
  }
  for (final widget in da.dashboardWidgets) {
    widgets.add(createWidgetfromjson(widget));
  }
  widgets.add({
    "config": {
      "datasources": [
        {
          "type": "entity",
          "entityAliasId": uuid,
          "dataKeys": [
            {
              "name": types[0],
              "type": "timeseries",
              "label": types[0],
              "color": "#70c6bb",
              "settings": {},
              "_hash": 0.7282710489093589,
              "funcBody":
                  "var value = prevValue + Math.random() * 50 - 25;\nif (value < -100) {\n\tvalue = -100;\n} else if (value > 100) {\n\tvalue = 100;\n}\nreturn value;"
            },
            {
              "name": types[1],
              "type": "timeseries",
              "label": types[1],
              "color": "#7aa6bb",
              "settings": {},
              "_hash": 0.7282710489093589,
              "funcBody":
                  "var value = prevValue + Math.random() * 50 - 25;\nif (value < -100) {\n\tvalue = -100;\n} else if (value > 100) {\n\tvalue = 100;\n}\nreturn value;"
            }
          ]
        }
      ],
      "title": chartTitle,
      "useDashboardTimewindow": true,
      "settings": {
        "shadowSize": 4,
        "fontColor": "#545454",
        "fontSize": 10,
        "xaxis": {"showLabels": true, "color": "#545454"},
        "yaxis": {"showLabels": true, "color": "#545454"},
        "grid": {
          "color": "#545454",
          "tickColor": "#DDDDDD",
          "verticalLines": true,
          "horizontalLines": true,
          "outlineWidth": 1
        },
        "legend": {
          "show": true,
          "position": "nw",
          "backgroundColor": "#f0f0f0",
          "backgroundOpacity": 0.85,
          "labelBoxBorderColor": "rgba(1, 1, 1, 0.45)"
        },
        "decimals": 1,
        "stack": false,
        "tooltipIndividual": false
      },
      "timewindow": {
        "realtime": {"timewindowMs": 60000}
      }
    },
    "bundleAlias": "charts",
    "typeAlias": "timeseries_bars_flot",
    "_typeAlias": "timeseries_bars_flot",
    "type": "timeseries",
    "isSystemType": "true"
  });
  if (aliases.isEmpty) {
    final s = json.encode(
      {
        "dashboardId": "d186af50-b4c3-11ec-aa6d-4b0464327e7a",
        "widgets": widgets,
        "entityAliases": [
          {
            "id": uuid,
            "alias": aliasName,
            "filter": {
              "type": "entityList",
              "resolveMultiple": true,
              "entityType": "DEVICE",
              "entityList": [deviceId]
            }
          }
        ]
      },
    );
    return s;
  } else {
    aliases.add({
      "id": uuid,
      "alias": aliasName,
      "filter": {
        "type": "entityList",
        "resolveMultiple": true,
        "entityType": "DEVICE",
        "entityList": [deviceId]
      }
    });
    final s = json.encode(
      {
        "dashboardId": "d186af50-b4c3-11ec-aa6d-4b0464327e7a",
        "widgets": widgets,
        "entityAliases": aliases,
      },
    );
    return s;
  }
}

Map<String, dynamic> createWidgetfromjson(ServerWidget sWidget) {
  return {
    "config": {
      "datasources": [
        {
          "type": "entity",
          "entityAliasId": sWidget.config.datasources[0].entityAliasId,
          "dataKeys": [
            {
              "name": sWidget.config.datasources[0].dataKeys[0].label,
              "type": "timeseries",
              "label": sWidget.config.datasources[0].dataKeys[0].label,
              "color": "#70c6bb",
              "settings": {},
              "_hash": 0.7282710489093589,
              "funcBody":
                  "var value = prevValue + Math.random() * 50 - 25;\nif (value < -100) {\n\tvalue = -100;\n} else if (value > 100) {\n\tvalue = 100;\n}\nreturn value;"
            },
            {
              "name": sWidget.config.datasources[0].dataKeys[1].label,
              "type": "timeseries",
              "label": sWidget.config.datasources[0].dataKeys[1].label,
              "color": "#7aa6bb",
              "settings": {},
              "_hash": 0.7282710489093589,
              "funcBody":
                  "var value = prevValue + Math.random() * 50 - 25;\nif (value < -100) {\n\tvalue = -100;\n} else if (value > 100) {\n\tvalue = 100;\n}\nreturn value;"
            }
          ]
        }
      ],
      "title": sWidget.config.title,
      "useDashboardTimewindow": true,
      "settings": {
        "shadowSize": 4,
        "fontColor": "#545454",
        "fontSize": 10,
        "xaxis": {"showLabels": true, "color": "#545454"},
        "yaxis": {"showLabels": true, "color": "#545454"},
        "grid": {
          "color": "#545454",
          "tickColor": "#DDDDDD",
          "verticalLines": true,
          "horizontalLines": true,
          "outlineWidth": 1
        },
        "legend": {
          "show": true,
          "position": "nw",
          "backgroundColor": "#f0f0f0",
          "backgroundOpacity": 0.85,
          "labelBoxBorderColor": "rgba(1, 1, 1, 0.45)"
        },
        "decimals": 1,
        "stack": false,
        "tooltipIndividual": false
      },
      "timewindow": {
        "realtime": {"timewindowMs": 60000}
      }
    },
    "bundleAlias": "charts",
    "typeAlias": "timeseries_bars_flot",
    "_typeAlias": "timeseries_bars_flot",
    "type": "timeseries",
    "isSystemType": "true"
  };
}

submitWebsocketCommand() {
  DashboardAliases da = DashboardAliases();
  List<Map> entityDataCmds = [];
  for (final widget in da.dashboardWidgets) {
    entityDataCmds.add({
      "query": {
        "entityFilter": {
          "type": "entityList",
          "resolveMultiple": true,
          "entityType": "DEVICE",
          "entityList": [
            getDeviceIdFromAliasId(widget.config.datasources[0].entityAliasId)
          ]
        },
        "pageLink": {
          "pageSize": 1024,
          "page": 0,
          "sortOrder": {
            "key": {"type": "ENTITY_FIELD", "key": "createdTime"},
            "direction": "DESC"
          }
        },
        "entityFields": [
          {"type": "ENTITY_FIELD", "key": "name"},
          {"type": "ENTITY_FIELD", "key": "label"},
          {"type": "ENTITY_FIELD", "key": "additionalInfo"}
        ],
        "latestValues": [
          {
            "type": "TIME_SERIES",
            "key": widget.config.datasources[0].dataKeys[0].label
          },
          {
            "type": "TIME_SERIES",
            "key": widget.config.datasources[0].dataKeys[1].label
          }
        ]
      },
      "cmdId": widget.cmdId
    });
  }
  final d = {
    "attrSubCmds": [],
    "tsSubCmds": [],
    "historyCmds": [],
    "entityDataCmds": entityDataCmds,
    "entityDataUnsubscribeCmds": [],
    "alarmDataCmds": [],
    "alarmDataUnsubscribeCmds": []
  };
  final s = json.encode(d);
  return s;
}

secondSubmitWebsocketCommand(String key1, String key2, int cmdId) {
  return json.encode({
    "attrSubCmds": [],
    "tsSubCmds": [],
    "historyCmds": [],
    "entityDataCmds": [
      {
        "cmdId": cmdId,
        "tsCmd": {
          "keys": [key1, key2],
          "startTs": 1649159943000,
          "timeWindow": 61000,
          "interval": 1000,
          "limit": 61,
          "agg": "AVG"
        }
      }
    ],
    "entityDataUnsubscribeCmds": [],
    "alarmDataCmds": [],
    "alarmDataUnsubscribeCmds": []
  });
}

String getDeviceIdFromAliasId(String aliasId) {
  String id = "";
  for (final alias in DashboardAliases().dashboardAlias) {
    if (alias.id == aliasId) {
      id = alias.deviceId;
    }
  }
  return id;
}
