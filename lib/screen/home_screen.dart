import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/model/device.dart';
import 'package:iot/provider/api_provider.dart';

class HomeScreen extends StatelessWidget {
  late BuildContext context;
  DropDownViewController dropDownViewController =
      Get.put(DropDownViewController());
  DropDownListController dropDownListController =
      Get.put(DropDownListController());
  TextEditingController chartTitleController = TextEditingController();
  Color warningColor = Colors.red;
  Color primaryColor = Colors.blue;
  ApiProvider apiProvider = ApiProvider();
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text("iot"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getDevicesFromServer,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
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
        ));
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
        onPressed: () =>
            title == "Add" ? checkTextFieldForAddChart() : Get.back(),
        child: Text(title),
        style: TextButton.styleFrom(primary: textColor));
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

  void addChart({required String deviceId, required String chartTitle}) {
    apiProvider
        .addChartServiceProvider(deviceId: deviceId, chartTitle: chartTitle)
        .then(
          (value) => value.fold(
            (l) {
              Get.back();
              showSnackBar("Widget added successfuly", primaryColor);
            },
            (r) {
              showSnackBar(r.message, warningColor);
            },
          ),
        );
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
