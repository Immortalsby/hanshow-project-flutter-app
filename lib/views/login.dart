import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../config/config.dart';
import '../widgets/my_toast.dart';
import '../widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import '../utils/shared_preferences_util.dart';
import '../models/crypt.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = ScrollController();
  double offset = 0;
  bool passwordInvisible = true;
  final _formKey = GlobalKey<FormState>();
  List _user = [];
  String? _errorText;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  _getErrorText() {
    return _errorText;
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(750, 1334),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/barbecue.svg",
              textTop: !kIsWeb &&Platform.isAndroid?"HS Project": "Hanshow Project",
              textBottom: "DashBoard",
              offset: offset,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: !kIsWeb && Platform.isAndroid ? double.infinity : 500,
                    padding: const EdgeInsets.only(bottom: 1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Login",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(45),
                                    fontFamily: "Poppins-Bold",
                                    letterSpacing: .6)),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            Text("Email",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: ScreenUtil().setSp(26))),
                            TextFormField(
                              controller: _emailController,
                              autofocus: true,
                              validator: (value) {
                                String pattern =
                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                    r"{0,253}[a-zA-Z0-9])?)*$";
                                RegExp regex = RegExp(pattern);
                                if (value == null ||
                                    value.isEmpty ||
                                    !regex.hasMatch(value)) {
                                  return 'Plese enter a valid email address';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  hintText: "eg: john.joe@hanshow.com",
                                  errorText: _getErrorText(),
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),

                            // Password Part

                            Text("Password",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: ScreenUtil().setSp(26))),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: passwordInvisible,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordInvisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        passwordInvisible = !passwordInvisible;
                                      });
                                    },
                                  ),
                                  hintText: "**********",
                                  errorText: _getErrorText(),
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 12.0)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter your password";
                                } else {
                                  return null;
                                }
                              },
                              onEditingComplete: () => login(),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(35),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(40)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(width: ScreenUtil().setHeight(40)),
                                InkWell(
                                  child: Container(
                                    width: 150,
                                    height: ScreenUtil().setHeight(100),
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: kActiveShadowColor,
                                              offset: const Offset(0.0, 8.0),
                                              blurRadius: 8.0)
                                        ]),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          login();
                                        },
                                        child: const Center(
                                          child: Text("LOGIN",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Poppins-Bold",
                                                  fontSize: 18,
                                                  letterSpacing: 1.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(35),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[

                       Text("Version: $version",
                          style: TextStyle(
                              fontSize: 12.0, fontFamily: "Poppins-Medium")),

                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "© 2022 by Boyuan SHI.\n All Rights Reserved.",
                        style: TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget horizontalLine() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);

    _emailController.text = SharedPreferenceUtil.getString('email')!.isEmpty
        ? ""
        : SharedPreferenceUtil.getString('email')!;
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  Future login() async {
    if (kIsWeb) {
      String _url =
          "https://projet.hanshow.eu/getUser.php?email=${_emailController.value.text}";
      var res = await http
          .get(Uri.parse(_url), headers: {"Accept": "application/json"});
      var _user = json.decode(res.body);

      String decodedPwd =
          Security(text: _passwordController.value.text).encrypt();
      if (_user.isEmpty || _user[0]['password'] != decodedPwd) {
        MyToast.show('Ops! Incorrect email or password');
        _passwordController.clear();
        setState(() {
          _errorText = ("Incorrect Email/Password");
        });
      } else {
        MyToast.show(
            "Welcome back ${_user[0]['name']!.toString().capitalize()}!");
        var datetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

        await SharedPreferenceUtil.setString('email', _user[0]["email"]);
        await SharedPreferenceUtil.setString('name', _user[0]["name"]);
        await SharedPreferenceUtil.setString('avator_url', _user[0]["avator_url"]);
        await SharedPreferenceUtil.setInt(
            'first_login', int.parse(_user[0]["first_login"]));
        await SharedPreferenceUtil.setString('last_login_date',
            _user[0]["last_login_date"].toString().substring(0, 19));
        await SharedPreferenceUtil.setBool("isLoggedIn", true);
        String _url =
        "https://projet.hanshow.eu/updateUser.php?query=update%20user%20set%20last_login_date='${datetime.toString()}'%20where%20email='${_user[0]["email"]}'";
        await http
          .get(Uri.parse(_url), headers: {"Accept": "application/json"});
        
        Navigator.popAndPushNamed(context, '/home');
      }
    } else {
      var _conn = await mysql.MySqlConnection.connect(setting);
      if (validateAndSave()) {
        String decodedPwd =
            Security(text: _passwordController.value.text).encrypt();
        String querySql =
            "select name, email, password,avator_url, first_login, last_login_date from user where email='${_emailController.value.text}' and password='$decodedPwd'";
        var result = await _conn.query(querySql);
        setState(() {
          _user = result.toList();
        });
        if (_user.isEmpty) {
          MyToast.show('Ops! Incorrect email or password');
          _passwordController.clear();
          setState(() {
            _errorText = ("Incorrect Email/Password");
          });
        } else {
          MyToast.show(
              "Welcome back ${_user[0]['name']!.toString().capitalize()}!");
          var datetime =
              DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
          await _conn.query(
              "update user set last_login_date='${datetime.toString()}' where email='${_user[0]["email"]}'");
          await SharedPreferenceUtil.setString('email', _user[0]["email"]);
          await SharedPreferenceUtil.setString('name', _user[0]["name"]);
          await SharedPreferenceUtil.setString('avator_url', _user[0]["avator_url"]);
          await SharedPreferenceUtil.setInt(
              'first_login', _user[0]["first_login"]);
          await SharedPreferenceUtil.setString('last_login_date',
              _user[0]["last_login_date"].toString().substring(0, 19));
          await SharedPreferenceUtil.setBool("isLoggedIn", true);
          Navigator.popAndPushNamed(context, '/home');
        }
      } else {
        MyToast.show('Ops, Invalid Email Address or Password');
      }
      await _conn.close();
    }
  }
}
