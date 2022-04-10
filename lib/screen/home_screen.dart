import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/api/services.dart';
import 'package:iot/model/chart_update.dart';
import 'package:iot/model/dashboard.dart';
import 'package:iot/model/dashboard_aliases.dart';
import 'package:iot/model/device.dart';
import 'package:iot/provider/api_provider.dart';
import 'package:iot/value/values.dart';
import 'package:iot/widget/live_sp_line_chart.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatelessWidget {
  late BuildContext context;
  DropDownViewController dropDownViewController =
      Get.put(DropDownViewController());
  DropDownListController dropDownListController =
      Get.put(DropDownListController());
  WidgetController widgetListController = Get.put(WidgetController());
  TextEditingController chartTitleController = TextEditingController();
  Color warningColor = Colors.red;
  Color primaryColor = Colors.blue;
  ApiProvider apiProvider = ApiProvider();
  int streamCount = 0;
  int widgetCount = 0;
  WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(
      "ws://192.168.100.226:8080/api/ws/plugins/telemetry?token=eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJnaGFzYWJAZG1pb3QuaXIiLCJzY29wZXMiOlsiVEVOQU5UX0FETUlOIl0sInVzZXJJZCI6Ijc4ZDYyZGVhLWFlNmUtMTFlYy04Nzg2LTQ3MWY0ZDFhZjE2NCIsImZpcnN0TmFtZSI6ImdoYXNhYiIsImxhc3ROYW1lIjoiZ2hhc2FiIiwiZW5hYmxlZCI6dHJ1ZSwiaXNQdWJsaWMiOmZhbHNlLCJ0ZW5hbnRJZCI6Ijc4ZDYyZGM4LWFlNmUtMTFlYy04Nzg2LTQ3MWY0ZDFhZjE2NCIsImN1c3RvbWVySWQiOiIxMzgxNDAwMC0xZGQyLTExYjItODA4MC04MDgwODA4MDgwODAiLCJpc3MiOiJ0aGluZ3Nib2FyZC5pbyIsImlhdCI6MTY0OTU3NzU4MSwiZXhwIjoxNjQ5NTg2NTgxfQ.0yPd6fIK-riUpv_XdY_ku_-LSDDnkg5mh5Vhp9SB7ybRTgg3HM4SWQhxj-H-_RRVWt71VdKJ-1DMSI-kdvqQ2w"));
  @override
  Widget build(BuildContext context) {
    this.context = context;
    setHomeDashboard(true);
    getWebsocketInfo();
    return Scaffold(
      appBar: AppBar(
        title: const Text("iot"),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                    itemCount: widgetListController.widgets.value.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          child: widgetListController.widgets.value[index]);
                    }),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getDevicesFromServer,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  void setHomeDashboard(bool firstRun) async {
    await setDashboard();
    widgetCount = DashboardAliases().dashboardWidgets.length;
    setWebsocket();
    setWidgets(firstRun);
  }

  void setWidgets(bool firstRun) {
    if (firstRun) {
      List<LiveSPLineChart> charts = [];
      for (final widget in DashboardAliases().dashboardWidgets) {
        charts.add(
            LiveSPLineChart(cmdId: widget.cmdId, title: widget.config.title));
      }
      widgetListController.updateWidgets(charts);
    } else {
      if (DashboardAliases().dashboardWidgets.isNotEmpty) {
        List<LiveSPLineChart> charts = widgetListController.widgets.value;
        ServerWidget widget = DashboardAliases()
            .dashboardWidgets[DashboardAliases().dashboardWidgets.length - 1];
        charts.add(
            LiveSPLineChart(cmdId: widget.cmdId, title: widget.config.title));
        widgetListController.updateWidgets(charts);
      } else {
        widgetListController.updateWidgets([]);
      }
    }
  }

  void setWebsocket() {
    streamCount = 0;
    channel.sink.add(submitWebsocketCommand());
  }

  void sendWidgetForListen() {
    for (final widget in DashboardAliases().dashboardWidgets) {
      channel.sink.add(secondSubmitWebsocketCommand(
          widget.config.datasources[0].dataKeys[0].label,
          widget.config.datasources[0].dataKeys[1].label,
          widget.cmdId));
    }
  }

  void getWebsocketInfo() {
    try {
      channel.stream.listen((event) {
        streamCount++;
        if (streamCount == widgetCount) {
          sendWidgetForListen();
        }
        if (streamCount > widgetCount) {
          try {
            ChartUpdate chup =
                ChartUpdate.fromJson(jsonDecode(event.toString()));
            if (!chup.update[0].timeseries.history) {
              DateTime time = DateTime.fromMillisecondsSinceEpoch(
                  chup.update[0].timeseries.labels[0].ts);
              LiveSPLineChart upWidget = widgetListController.widgets.value
                  .firstWhere((element) => element.cmdId == chup.cmdId);
              upWidget.addLine(
                  int.parse(chup.update[0].timeseries.labels[0].value),
                  int.parse(chup.update[0].timeseries.labels[1].value),
                  time);
            }
          } catch (ex) {
            print(ex);
          }
        }
      }, onDone: () {
        print("channel");
      }, onError: (e) {
        print(e);
      });
    } catch (err) {
      print("object");
    }
  }

  getDevicesFromServer() async {
    chartTitleController.clear();
    await apiProvider.getDevicesProvider().then((value) => value.fold(
        (l) => showAddChartDialog(l),
        (r) => showSnackBar(r.message, warningColor)));
  }

  void showAddChartDialog(Device device) async {
    List<Data> data = device.result.data;
    dropDownListController.updateValue(data);
    dropDownViewController.updateValue(
        dropDownListController.dropdownListValue.value.elementAt(0));
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(15),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      title: "Add Chart",
      cancel: createTextButton("Cancel", warningColor),
      confirm: createTextButton("Add", primaryColor),
      content: Column(
        children: [
          createDevicesDropDown(),
          createHorizontalSpace(15),
          createTextField("Chart Title", chartTitleController),
        ],
      ),
    );
  }

  Widget createHorizontalSpace(double height) {
    return SizedBox(height: height);
  }

  Widget createDevicesDropDown() {
    return Obx(
      () {
        return DropdownButton<Data>(
          hint: const Text("Device Id"),
          value: dropDownViewController.dropdownViewValue.value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (Data? newValue) {
            dropDownViewController
                .updateValue(newValue ?? Data(id: "", name: ""));
          },
          items: dropDownListController.dropdownListValue.value
              .map<DropdownMenuItem<Data>>((Data value) {
            return DropdownMenuItem<Data>(
              value: value,
              child: Text("${value.name} : ${value.id}"),
            );
          }).toList(),
        );
      },
    );
  }

  Widget createTextField(String hint, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(fontSize: 13),
      ),
      controller: controller,
    );
  }

  Widget createTextButton(String title, Color textColor) {
    return TextButton(
      onPressed: () {
        Get.back();
        if (title == "Add") {
          checkTextFieldForAddChart();
        }
      },
      child: Text(title),
      style: TextButton.styleFrom(primary: textColor),
    );
  }

  void checkTextFieldForAddChart() {
    if (chartTitleController.text.isNotEmpty) {
      addChart(
          deviceId: dropDownViewController.dropdownViewValue.value.id,
          chartTitle: chartTitleController.text);
    } else {
      showSnackBar("Please fill text fields", warningColor);
    }
  }

  void showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
  }

  void addChart({required String deviceId, required String chartTitle}) async {
    bool containAlias = dashboardContainAlias(deviceId);
    var deviceTypes =
        await apiProvider.getDeviceTypesProvider(deviceId: deviceId);
    if (containAlias) {
      apiProvider
          .addChartServiceWithAliasProvider(
              chartTitle: chartTitle,
              aliasId: getAliasIdByDeviceId(deviceId),
              types: deviceTypes)
          .then(
            (value) => value.fold(
              (l) async {
                showSnackBar("Widget added successfuly", primaryColor);
                setHomeDashboard(false);
              },
              (r) {
                showSnackBar(r.message, warningColor);
              },
            ),
          );
    } else {
      String uuid = const Uuid().v4();
      apiProvider
          .addChartServiceWithoutAliasProvider(
              chartTitle: chartTitle,
              deviceId: deviceId,
              uuid: uuid,
              aliasName: uuid.substring(0, 6),
              types: deviceTypes)
          .then(
            (value) => value.fold(
              (l) {
                showSnackBar("Widget added successfuly", primaryColor);
                setHomeDashboard(false);
              },
              (r) {
                showSnackBar(r.message, warningColor);
              },
            ),
          );
    }
  }
}

String getAliasIdByDeviceId(String deviceId) {
  String id = "";
  for (final alias in DashboardAliases().dashboardAlias) {
    if (deviceId == alias.deviceId) {
      id = alias.id;
    }
  }
  return id;
}

bool dashboardContainAlias(String deviceId) {
  DashboardAliases da = DashboardAliases();
  for (final alias in da.dashboardAlias) {
    if (deviceId == alias.deviceId) {
      return true;
    }
  }
  return false;
}

class WidgetController extends GetxController {
  var widgets = RxList<LiveSPLineChart>();

  updateWidgets(List<LiveSPLineChart> newWidgets) {
    widgets(newWidgets);
    widgets.refresh();
  }

  removeWidget(int cmdId) {
    widgets.removeWhere((element) => element.cmdId == cmdId);
    widgets.refresh();
  }
}

class DropDownViewController extends GetxController {
  var dropdownViewValue = Data(id: "", name: "").obs;
  updateValue(Data newValue) {
    dropdownViewValue(newValue);
  }
}

class DropDownListController extends GetxController {
  var dropdownListValue = [Data(id: "", name: "")].obs;
  updateValue(List<Data> newValue) {
    dropdownListValue(newValue);
  }
}
