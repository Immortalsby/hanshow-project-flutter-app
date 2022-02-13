import 'dart:async';
import 'package:hanshow_project_google_sheets/config/config.dart';
import 'package:gsheets/gsheets.dart';

final cred = GsheetsCred();

class Todo {
  final int? no;
  final String? address;
  final String? client;
  final String? id;
  final String? projectName;
  final int? qty;
  final String? serviceType;
  final DateTime? completeDate;
  final DateTime? dueDate;
  final String? projectManager;
  final String? serverIp;
  final DateTime? startDate;
  final String? status;
  final String? taskOwner;
  final String? chronoStatus;
  final DateTime? dateChronopost;
  final String? numberChronopost;
  final String? remarks;

  const Todo(
      {
      this.no,
      this.id,
      this.serviceType,
      this.client,
      this.projectName,
      this.address,
      this.qty,
      this.serverIp,
      this.projectManager,
      this.status,
      this.startDate,
      this.dueDate,
      this.completeDate,
      this.taskOwner,
      this.chronoStatus,
      this.dateChronopost,
      this.numberChronopost,
      this.remarks});

  factory Todo.fromGsheets(Map<String, dynamic> json) {
    DateTime? dateValidate(String time) {
      var initDate = DateTime(1899, 12, 30);
      return initDate.add(Duration(days: int.tryParse(time) ?? 0)) == initDate
          ? null
          : initDate.add(Duration(days: int.tryParse(time) ?? 0));
    }

    return Todo(
      no: int.tryParse(json['No'] ?? ''),
      address: json['Address'],
      client: json['Client'],
      id: json['ID'],
      projectName: json['Project Name'],
      qty: int.tryParse(json['Qty'] ?? ''),
      serviceType: json['Service Type'],
      completeDate: dateValidate(json['Complete Date']),
      dueDate: dateValidate(json['Due Date']),
      projectManager: json['Project Manager'],
      serverIp: json['Server IP'],
      startDate: dateValidate(json['Start Date']),
      status: json['Status'],
      taskOwner: json['Task Owner'],
      chronoStatus: json['Chrono Status'],
      dateChronopost: dateValidate(json['Date Chronopost']),
      numberChronopost: json['Number Chronopost'],
      remarks: json['Remarks'],
    );
  }

  Map<String, dynamic> toGsheets() {
    return {
      'No': no,
      'Address': address,
      'Client': client,
      'ID': id,
      'Project Name': projectName,
      'Qty': qty,
      'Service Type': serviceType,
      'Complete Date': completeDate,
      'Due Date': dueDate,
      'Project Manager': projectManager,
      'Server IP': serverIp,
      'Start Date': startDate,
      'Status': status,
      'Task Owner': taskOwner,
      'Chrono Status': chronoStatus,
      'Date Chronopost': dateChronopost,
      'Number Chronopost': numberChronopost,
      'Remarks': remarks,
    };
  }

  @override
  String toString() => 'Member{Server IP: $serverIp, Start Date: $startDate}';
}

class TodoManager {
  final GSheets _gsheets = GSheets(cred.credentials);
  Spreadsheet? _spreadsheet;
  Worksheet? _todoSheet;

  Future<void> init() async {
    _spreadsheet ??= await _gsheets.spreadsheet(cred.spreadsheetId);
    _todoSheet ??= _spreadsheet!.worksheetByTitle('ToDoList');
  }

  Future<List<Todo>>? getAll() async {
    await init();
    final List<Map<String, String>>? member;
    member = await _todoSheet!.values.map.allRows();
    return member!.map<Todo>((json) => Todo.fromGsheets(json)).toList();
    // return jsonEncode(member);
  }

  Future<List>? getColumnName() async {
    await init();
    final List<Map<String, String>>? member;
    member = await _todoSheet!.values.map.allRows();
    List res = [];
    for(var key in member!.toList()[0].keys) {
      res.add(key);
    }

    return res;
  }

  Future<bool> insert(int row, String columnName, value) async {
    await init();
    return _todoSheet!.values.insertValueByKeys(
      value,
      columnKey: columnName,
      rowKey: row,
    );
    
  }
}



class TodoConfig {
  final String? client;
  final String? serviceType;
  final String? projectManager;
  final String? status;
  final String? taskOwner;
  final String? chronoStatus;

  const TodoConfig(
      {
      this.serviceType,
      this.client,
      this.projectManager,
      this.status,
      this.taskOwner,
      this.chronoStatus,
      });

  factory TodoConfig.fromGsheets(Map<String, dynamic> json) {
    return TodoConfig(
      client: json['Client'],
      serviceType: json['Service Type'],
      projectManager: json['Project Manager'],
      status: json['Status'],
      taskOwner: json['Task Owner'],
      chronoStatus: json['Chrono Status'],
    );
  }

  Map<String, dynamic> toGsheets() {
    return {
      'Client': client,
      'Service Type': serviceType,
      'Project Manager': projectManager,
      'Status': status,
      'Task Owner': taskOwner,
      'Chrono Status': chronoStatus,
    };
  }

  // @override
  // String toString() => 'Member{Client: $client, Start Date: $startDate}';
}


class TodoConfigManager {
  final GSheets _gsheets = GSheets(cred.credentials);
  Spreadsheet? _spreadsheet;
  Worksheet? _todoConfigSheet;

  Future<void> init() async {
    _spreadsheet ??= await _gsheets.spreadsheet(cred.spreadsheetId);
    _todoConfigSheet ??= _spreadsheet!.worksheetByTitle('ToDoListConfig');
  }

  Future<List<TodoConfig>>? getAll() async {
    await init();
    final List<Map<String, String>>? member;
    member = await _todoConfigSheet!.values.map.allRows();
    return member!.map<TodoConfig>((json) => TodoConfig.fromGsheets(json)).toList();
    // return jsonEncode(member);
  }

  Future<List>? getColumnName() async {
    await init();
    final List<Map<String, String>>? member;
    member = await _todoConfigSheet!.values.map.allRows();
    List res = [];
    for(var key in member!.toList()[0].keys) {
      res.add(key);
    }

    return res;
  }
}