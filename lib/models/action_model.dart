import 'dart:async';
import 'package:hanshow_project_google_sheets/config/config.dart';
import 'package:gsheets/gsheets.dart';

final cred = GsheetsCred();

class ActionPlan {
  final String? client;
  final String? action;
  final DateTime? dueDate;
  final DateTime? startDate;
  final String? status;
  final String? taskOwner;
  final String? remarks;

  const ActionPlan(
      {this.action,
      this.taskOwner,
      this.client,
      this.status,
      this.startDate,
      this.dueDate,
      this.remarks});

  factory ActionPlan.fromGsheets(Map<String, dynamic> json) {
    DateTime? dateValidate(String time) {
      var initDate = DateTime(1899, 12, 30);
      return initDate.add(Duration(days: int.tryParse(time) ?? 0)) == initDate
          ? null
          : initDate.add(Duration(days: int.tryParse(time) ?? 0));
    }

    return ActionPlan(
      client: json['Client'],
      action: json['Action'],
      dueDate: dateValidate(json['Due Date']),
      startDate: dateValidate(json['Start Date']),
      status: json['Status'],
      taskOwner: json['Task Owner'],
      remarks: json['Remarks'],
    );
  }

  Map<String, dynamic> toGsheets() {
    return {
      'Client': client,
      'Action': action,
      'Due Date': dueDate,
      'Start Date': startDate,
      'Status': status,
      'Task Owner': taskOwner,
      'Remarks': remarks,
    };
  }

  @override
  String toString() =>
      'Member{Client: $client, Action: $action,Due Date:$dueDate,Start Date:$startDate,Status:$status,Task Owner:$taskOwner,Remarks:$remarks}';
}

class ActionPlanManager {
  final GSheets _gsheets = GSheets(cred.credentials);
  Spreadsheet? _spreadsheet;
  Worksheet? _actionSheet;

  Future<void> init() async {
    _spreadsheet ??= await _gsheets.spreadsheet(cred.spreadsheetId);
    _actionSheet ??= _spreadsheet!.worksheetByTitle('ActionPlan');
  }

  Future<List<ActionPlan>>? getAll() async {
    await init();
    final List<Map<String, String>>? member;
    member = await _actionSheet!.values.map.allRows();
    return member!.map<ActionPlan>((json) => ActionPlan.fromGsheets(json)).toList();
    // return jsonEncode(member);
  }

  Future<List>? getColumnName() async {
    await init();
    final List<Map<String, String>>? member;
    member = await _actionSheet!.values.map.allRows();
    List res = [];
    for (var key in member!.toList()[0].keys) {
      res.add(key);
    }

    return res;
  }

  Future<bool> insert(int row, int column, value) async {
    await init();
    return _actionSheet!.values.insertValue(
      value,
      column: column + 1,
      row: row + 2,
    );
  }
}


