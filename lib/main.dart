import 'package:flutter/material.dart';
import 'package:hanshow_project_google_sheets/config/shared_preferences_util.dart';
import 'package:hanshow_project_google_sheets/views/login.dart';
import 'package:hanshow_project_google_sheets/views/team.dart';
import 'package:hanshow_project_google_sheets/views/home.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:oktoast/oktoast.dart';

Future<void> main() async {
  runApp(const MyApp());
  SharedPreferenceUtil.getInstance();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      textStyle: const TextStyle(fontSize: 19.0, color: Colors.white),
      backgroundColor: Colors.grey,
      radius: 10.0,
      animationCurve: Curves.easeIn,
      animationDuration: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 3),
      child: MaterialApp(
          navigatorKey: NavigationService.navigationKey,
          debugShowCheckedModeBanner: false,
          title: 'Hanshow Project',
          theme: ThemeData(
            fontFamily: "Poppins",
            primarySwatch: Colors.blueGrey,
          ),
          routes: {
            '/home': (context) => const Home(),
            '/team': (context) => const Team(),
            '/login': (context) => const LoginScreen(),
          },
          initialRoute:
              SharedPreferenceUtil.getBool('isLoggedIn')! ? '/home' : '/login',
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/home':
                return MaterialPageRoute(builder: (_) => const Home());
              case '/team':
                return MaterialPageRoute(builder: (_) => const Team());
              case '/login':
                return MaterialPageRoute(builder: (_) => const LoginScreen());
              case '/':
                return MaterialPageRoute(builder: (_) => const LoginScreen());
              default:
                return null;
            }
          }),
    );
  }
}