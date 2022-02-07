// ignore_for_file: avoid_print

import 'dart:async';
import 'package:hanshow_project_google_sheets/config/config.dart';
import 'package:gsheets/gsheets.dart';

final cred = GsheetsCred();

class Team {
  const Team({this.name, this.email, this.role, this.team, this.gmail});
  final String? name;
  final String? email;
  final String? role;
  final String? team;
  final String? gmail;

  factory Team.fromGsheets(Map<String, dynamic> json) {
    return Team(
        name: json['Name'],
        email: json['Email'],
        role: json['Role'],
        team: json['Team'],
        gmail: json['Gmail']);
  }

  Map<String, dynamic> toGsheets() {
    return {
      'Name': name,
      'Email': email,
      'Role': role,
      'Team': team,
      'Gmail': gmail
    };
  }

  @override
  String toString() =>
      'Member{Name: $name, Email: $email, Role: $role, Team: $team, Gmail: $gmail}';
}

class TeamManager {
  final GSheets _gsheets = GSheets(cred.credentials);
  Spreadsheet? _spreadsheet;
  Worksheet? _teamSheet;

  Future<void> init() async {
    _spreadsheet ??= await _gsheets.spreadsheet(cred.spreadsheetId);
    _teamSheet ??= _spreadsheet!.worksheetByTitle('Team');
  }

  Future<List<Team>>? getAll() async {
    await init();
    final List<Map<String, String>>? member;
    member = await _teamSheet!.values.map.allRows();

    return member!.map<Team>((json) => Team.fromGsheets(json)).toList();
  }

  Future<bool> insert(int row, int column, value) async {
    await init();
    print("insert to Team: row:$row, column:$column, value:$value");
    return _teamSheet!.values.insertValue(
      value,
      column: column + 1,
      row: row + 2,
    );
  }
}
