import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import '../config/config.dart';
import 'package:http/http.dart' as http;

class GetHistory {
  Future all() async {
    if (kIsWeb) {
      String _url = "https://projet.hanshow.eu/getHistory.php";
      var res = await http
          .get(Uri.parse(_url), headers: {"Accept": "application/json"});
      var result = json.decode(res.body);
      return (result.toList());
    } else {
      var _conn = await mysql.MySqlConnection.connect(setting);
      String querySql = 'select * from history';

      var result = await _conn.query(querySql);

      await _conn.close();
      return (result.toList());
    }
  }
}
