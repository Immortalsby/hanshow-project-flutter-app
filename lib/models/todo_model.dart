// // ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:hanshow_project_google_sheets/config/config.dart';
import 'package:gsheets/gsheets.dart';

final cred = GsheetsCred();

class Todo {
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
  final DateTime? dateChronapost;
  final String? numberChronopost;
  final String? remarks;
  static int counter = 17;

  const Todo({this.id, this.serviceType, this.client, this.projectName, this.address, this.qty,
  this.serverIp, this.projectManager, this.status, this.startDate, this.dueDate, this.completeDate,this.taskOwner,
  this.chronoStatus, this.dateChronapost, this.numberChronopost, this.remarks});

  factory Todo.fromGsheets(Map<String, dynamic> json) {
    return Todo(
        address:json['Address'],
        client:json['Client'],
        id:json['ID'],
        projectName:json['Project Name'],
        qty:int.tryParse(json['Qty'] ?? ''),
        serviceType:json['Service Type'],
        completeDate:DateTime.tryParse(json['Complete Date'] ?? ''),
        dueDate:DateTime.tryParse(json['Due Date'] ?? ''),
        projectManager:json['Project Manager'],
        serverIp:json['Server IP'],
        startDate:DateTime.tryParse(json['Start Date'] ?? ''),
        status:json['Status'],
        taskOwner:json['Task Owner'],
        chronoStatus:json['Chrono Status'],
        dateChronapost:DateTime.tryParse(json['Date Chronapost'] ?? ''),
        numberChronopost:json['Number Chronopost'],
        remarks:json['Remarks'],
        );
  }

  Map<String, dynamic> toGsheets() {
    return {
      'Address': address,
      'Client': client,
      'ID': id,
      'Project Name': projectName,
      'Qty': qty,
      'Service Type': serviceType,
      'Complete Date': completeDate,
      'Due Date': dueDate,
      'Project Manager': projectManager,
      'Server Ip': serverIp,
      'Start Date': startDate,
      'Status': status,
      'Task Own': taskOwner,
      'Chrono Status': chronoStatus,
      'Date Chronapost': dateChronapost,
      'Number Chronopost': numberChronopost,
      'Remarks': remarks,
    };
  }
      @override
  String toString() =>
      'Member{ServerIp: $serverIp, StartDate: $startDate}';
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

    // print(member!.toList()[0]);
    return member!.map<Todo>((json) => Todo.fromGsheets(json)).toList();
    // return jsonEncode(member);
  }

  Future<List<Todo>>? getRowName() async {
    await init();
    final List<Map<String, String>>? member;
    member = await _todoSheet!.values.map.allRows();

    return member!.map<Todo>((json) => Todo.fromGsheets(json)).toList();
  }

  Future<bool> insert(int row, int column, value) async {
    await init();
    print("insert to Todo: row:$row, column:$column, value:$value");
    return _todoSheet!.values.insertValue(
      value,
      column: column + 1,
      row: row + 2,
    );
  }
}
