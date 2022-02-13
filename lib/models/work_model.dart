import 'dart:async';
import 'package:hanshow_project_google_sheets/config/config.dart';
import 'package:gsheets/gsheets.dart';

final cred = GsheetsCred();

class Work {
  const Work(
      {this.name,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.oncall});
  final String? name;
  final String? monday;
  final String? tuesday;
  final String? wednesday;
  final String? thursday;
  final String? friday;
  final String? oncall;

  factory Work.fromGsheets(Map<String, dynamic> json) {
    return Work(
        name: json['Name'],
        monday: json['Monday'],
        tuesday: json['Tuesday'],
        wednesday: json['Wednesday'],
        thursday: json['Thursday'],
        friday: json['Friday'],
        oncall: json['On-Call']);
  }

  Map<String, dynamic> toGsheets() {
    return {
      'Name': name,
      'Monday': monday,
      'Tuesday': tuesday,
      'Wednesday': wednesday,
      'Thursday': thursday,
      'Friday': friday,
      '': oncall,
    };
  }

  @override
  String toString() =>
      'Member{Name: $name, Monday: $monday, Tuesday: $tuesday, Wednesday: $wednesday, Thursday: $thursday, Friday: $friday, On-Call:$oncall}';
}

class WorkManager {
  final GSheets _gsheets = GSheets(cred.credentials);
  Spreadsheet? _spreadsheet;
  Worksheet? _workSheet;

  Future<void> init() async {
    _spreadsheet ??= await _gsheets.spreadsheet(cred.spreadsheetId);
    _workSheet ??= _spreadsheet!.worksheetByTitle('WorkingPlan');
  }

  Future<List<Work>>? getAll() async {
    await init();
    final List<Map<String, String>>? member;
    member = await _workSheet!.values.map.allRows();
    return member!.map<Work>((json) => Work.fromGsheets(json)).toList();
  }

  // Future<bool> insert(int row, int column, value) async {
  //   await init();
  //   return _workSheet!.values.insertValue(
  //     value,
  //     column: column + 1,
  //     row: row + 2,
  //   );
  // }
}
