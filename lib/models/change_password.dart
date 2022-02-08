import '../config/config.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import '../utils/shared_preferences_util.dart';

class ChangePassword {

  Future getPassword(email) async {
    var _conn = await mysql.MySqlConnection.connect(setting);
    var result = await _conn.query("select password from user where email='$email'");
    await _conn.close();
    return result.toList()[0]['password'].toString();
  }

  Future<bool> change(email, oldPass, newPass) async {
    var _conn = await mysql.MySqlConnection.connect(setting);
    String querySql =
        'update user set password=?, first_login=1 where email=? and password=?';
    var result = await _conn.query(querySql, [newPass, email, oldPass]);
    result = await _conn.query("select password from user where email='$email'");
    await _conn.close();
    if (result.toList()[0]['password'].toString() == newPass){
      SharedPreferenceUtil.setInt('first_login', 1);
      return true;
    }
      return false;
  }
}
