import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import 'package:mysql1/mysql1.dart' as mysql;

class AddHistory {
  var dict = {
    0: "A",
    1: "B",
    2: "C",
    3: "D",
    4: "E",
    5: "F",
    6: "G",
    7: "H",
    8: "I",
    9: "J",
    10: "K",
    11: "L",
    12: "M",
    13: "N",
    14: "O",
    15: "P",
    16: "Q",
    17: "R",
    18: "S",
    19: "T",
    20: "U",
    21: "V",
    22: "W",
    23: "X",
    24: "Y",
    25: "Z",
  };

  Future add(
      username, originalData, newData, targetSheet, int row, int column) async {
    String position = dict[column]! + (row + 2).toString();
    
    if (kIsWeb) {
      var url = "https://projet.hanshow.eu/addHistory.php";
      await http.post(Uri.parse(url), body: {
        "username": username,
        "original_data": originalData,
        "new_data": newData,
        "target_sheet": targetSheet,
        "position": position
      });

    } else {
      var _conn = await mysql.MySqlConnection.connect(setting);
      String querySql =
          '''insert into history (username, original_data, new_data, target_sheet, position) 
        values (?, ?, ?, ?, ?)''';

      await _conn.query(
          querySql, [username, originalData, newData, targetSheet, position]);

      await _conn.close();
    }
  }
}
