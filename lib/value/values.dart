import 'dart:convert';

addChartReqJson({required String deviceId, required String chartTitle}) {
  return json.encode({
    "dashboardId": "242af170-af3e-11ec-9e4e-a765ace46902",
    "widgets": [
      {
        "config": {
          "datasources": [
            {
              "type": "entity",
              "entityAliasId": "48820ad1-c755-459a-8494-cd6549d99bb1",
              "dataKeys": [
                {
                  "name": "humidity",
                  "type": "timeseries",
                  "label": "humidity",
                  "color": "#70c6bb",
                  "settings": {},
                  "_hash": 0.7282710489093589,
                  "funcBody":
                      "var value = prevValue + Math.random() * 50 - 25;\nif (value < -100) {\n\tvalue = -100;\n} else if (value > 100) {\n\tvalue = 100;\n}\nreturn value;"
                },
                {
                  "name": "temp",
                  "type": "timeseries",
                  "label": "temp",
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
      }
    ],
    "entityAliases": [
      {
        "id": "48820ad1-c755-459a-8494-cd6549d99bb1",
        "alias": "alias-1",
        "filter": {
          "type": "entityList",
          "resolveMultiple": true,
          "entityType": "DEVICE",
          "entityList": [deviceId]
        }
      }
    ]
  });
}
