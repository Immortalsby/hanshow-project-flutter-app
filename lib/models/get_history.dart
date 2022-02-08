import 'package:mysql1/mysql1.dart' as mysql;
import '../config/config.dart';

class GetHistory {
  Future all() async {

    var _conn = await mysql.MySqlConnection.connect(setting);
    String querySql = 'select * from history';

    var result = await _conn.query(querySql);

    await _conn.close();
    return (result.toList());
  }
}