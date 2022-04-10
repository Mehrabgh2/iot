class ChartUpdate {
  int cmdId;
  List<Update> update;

  ChartUpdate({required this.cmdId, required this.update});

  factory ChartUpdate.fromJson(Map<String, dynamic> json) {
    final cmdId = json['cmdId'];
    List<Update> update = [];
    json['update'].forEach((v) {
      update.add(Update.fromJson(v));
    });
    return ChartUpdate(cmdId: cmdId, update: update);
  }
}

class Update {
  Timeseries timeseries;

  Update({required this.timeseries});

  factory Update.fromJson(Map<String, dynamic> json) {
    bool history = true;
    for (final h in json['timeseries'].keys) {
      int s = json['timeseries'][h].length;
      if (s < 2) history = false;
    }
    final timeseries = Timeseries.fromJson(json['timeseries'], history);
    return Update(timeseries: timeseries);
  }
}

class Timeseries {
  List<Label> labels;
  bool history;

  Timeseries({required this.labels, required this.history});

  factory Timeseries.fromJson(Map<String, dynamic> json, bool history) {
    List<Label> labels = [];
    for (final lab in json.keys) {
      json[lab].forEach((v) {
        labels.add(Label.fromJson(v, lab));
      });
    }
    return Timeseries(labels: labels, history: history);
  }
}

class Label {
  int ts;
  String value;
  String label;

  Label({required this.ts, required this.value, required this.label});

  factory Label.fromJson(Map<String, dynamic> json, String label) {
    final ts = json['ts'];
    final value = json['value'];
    return Label(ts: ts, value: value, label: label);
  }
}
