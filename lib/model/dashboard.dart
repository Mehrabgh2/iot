class Dashboard {
  int code;
  String message;
  Result result;

  Dashboard({required this.code, required this.message, required this.result});

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final message = json['message'];
    final result =
        json['result'] != null ? Result.fromJson(json['result']) : null;
    return Dashboard(code: code, message: message, result: result!);
  }
}

class Result {
  TenantId tenantId;
  String title;
  Configuration configuration;

  Result(
      {required this.tenantId,
      required this.title,
      required this.configuration});

  factory Result.fromJson(Map<String, dynamic> json) {
    final tenantId =
        json['tenantId'] != null ? TenantId.fromJson(json['tenantId']) : null;
    final title = json['title'];
    final configuration = json['configuration'] != null
        ? Configuration.fromJson(json['configuration'])
        : null;
    return Result(
        tenantId: tenantId!, title: title, configuration: configuration!);
  }
}

class TenantId {
  String entityType;
  String id;

  TenantId({required this.entityType, required this.id});

  factory TenantId.fromJson(Map<String, dynamic> json) {
    final entityType = json['entityType'];
    final id = json['id'];
    return TenantId(entityType: entityType, id: id);
  }
}

class Configuration {
  Widgets widgets;
  EntityAliases entityAliases;

  Configuration({required this.widgets, required this.entityAliases});

  factory Configuration.fromJson(Map<String, dynamic> json) {
    final widgets =
        json['widgets'] != null ? Widgets.fromJson(json['widgets']) : null;
    final entityAliases = json['entityAliases'] != null
        ? EntityAliases.fromJson(json['entityAliases'])
        : null;
    return Configuration(widgets: widgets!, entityAliases: entityAliases!);
  }
}

class Widgets {
  List<ServerWidget> serverWidgets;

  Widgets({required this.serverWidgets});

  factory Widgets.fromJson(Map<String, dynamic> json) {
    List<ServerWidget> serverWidgets = [];
    for (final widgetId in json.keys) {
      serverWidgets.add(ServerWidget.fromJson(json[widgetId]));
    }
    return Widgets(serverWidgets: serverWidgets);
  }
}

class ServerWidget {
  String bundleAlias;
  String typeAlias;
  String type;
  Config config;
  String id;
  int cmdId = 0;

  ServerWidget(
      {required this.bundleAlias,
      required this.typeAlias,
      required this.type,
      required this.config,
      required this.id});

  factory ServerWidget.fromJson(Map<String, dynamic> json) {
    final bundleAlias = json['bundleAlias'];
    final typeAlias = json['typeAlias'];
    final type = json['type'];
    final config =
        json['config'] != null ? Config.fromJson(json['config']) : null;
    final id = json['id'];
    return ServerWidget(
        bundleAlias: bundleAlias,
        typeAlias: typeAlias,
        type: type,
        config: config!,
        id: id);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['config'] = config.toJson();
    data['bundleAlias'] = bundleAlias;
    data['typeAlias'] = typeAlias;
    data['type'] = type;
    return data;
  }
}

class Config {
  List<Datasources> datasources;
  String title;

  Config({required this.datasources, required this.title});

  factory Config.fromJson(Map<String, dynamic> json) {
    List<Datasources> datasources = [];
    json['datasources'].forEach((v) {
      datasources.add(Datasources.fromJson(v));
    });
    final title = json['title'];
    return Config(datasources: datasources, title: title);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['datasources'] = datasources.map((v) => v.toJson()).toList();
    data['title'] = title;
    return data;
  }
}

class Datasources {
  String type;
  String entityAliasId;
  List<DataKeys> dataKeys;

  Datasources(
      {required this.type,
      required this.entityAliasId,
      required this.dataKeys});

  factory Datasources.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final entityAliasId = json['entityAliasId'];
    List<DataKeys> dataKeys = [];
    json['dataKeys'].forEach((v) {
      dataKeys.add(DataKeys.fromJson(v));
    });
    return Datasources(
        type: type, entityAliasId: entityAliasId, dataKeys: dataKeys);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = type;
    data['entityAliasId'] = entityAliasId;
    data['dataKeys'] = dataKeys.map((v) => v.toJson()).toList();
    return data;
  }
}

class DataKeys {
  String name;
  String type;
  String label;
  String color;

  DataKeys(
      {required this.name,
      required this.type,
      required this.label,
      required this.color});

  factory DataKeys.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final type = json['type'];
    final label = json['label'];
    final color = json['color'];
    return DataKeys(name: name, type: type, label: label, color: color);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['label'] = label;
    data['color'] = color;
    return data;
  }
}

class EntityAliases {
  List<Alias> aliases;

  EntityAliases({required this.aliases});

  factory EntityAliases.fromJson(Map<String, dynamic> json) {
    List<Alias> aliases = [];
    for (final aliasId in json.keys) {
      aliases.add(Alias.fromJson(json[aliasId]));
    }
    return EntityAliases(aliases: aliases);
  }
}

class Alias {
  String id;
  String alias;
  Filter filter;

  Alias({required this.id, required this.alias, required this.filter});

  factory Alias.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final alias = json['alias'];
    final filter =
        json['filter'] != null ? Filter.fromJson(json['filter']) : null;
    return Alias(id: id, alias: alias, filter: filter!);
  }
}

class Filter {
  List<String> entityList;

  Filter({required this.entityList});

  factory Filter.fromJson(Map<String, dynamic> json) {
    final entityList = json['entityList'].cast<String>();
    return Filter(entityList: entityList);
  }
}
