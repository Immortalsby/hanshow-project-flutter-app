import 'package:flutter/material.dart';
import 'package:hanshow_project_google_sheets/views/left_sidebar.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../custom_animations/delayed_animation.dart';
import 'package:intl/intl.dart';
import '../config/shared_preferences_util.dart';
import '../config/constant.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import '../widgets/my_toast.dart';
import 'change_password.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var dark = true;
  var color = const Color.fromARGB(255, 240, 234, 234);
  final int delayedAmount = 500;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (SharedPreferenceUtil.getBool('isLoggedIn') == false) {
        navService.pushNamed('/login', args: 'Your are not logged in');
      }
    });
    dark = SharedPreferenceUtil.getBool('dark_mode')!;
    color = SharedPreferenceUtil.getBool('dark_mode')!
        ? const Color.fromARGB(255, 240, 234, 234)
        : const Color.fromARGB(255, 14, 14, 22);
    if (SharedPreferenceUtil.getInt('first_login') == 0) {
      Future.delayed(
          const Duration(seconds: 0),
          () => showDialog(
              context: context,
              builder: (context) {
                return const ChangePasswordView();
              }));
    }
  }

  String? weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    List list_1 = [1, 21, 31, 41, 51];
    List list_2 = [2, 22, 32, 42, 52];
    List list_3 = [3, 23, 33, 43, 53];
    dayOfYear = ((dayOfYear - date.weekday + 10) / 7).floor();
    String? res;
    if (list_1.contains(dayOfYear)) {
      res = dayOfYear.toString() + "st";
    } else if (list_2.contains(dayOfYear)) {
      res = dayOfYear.toString() + "nd";
    } else if (list_3.contains(dayOfYear)) {
      res = dayOfYear.toString() + "rd";
    } else {
      res = dayOfYear.toString() + "th";
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Hanshow Project"),
          elevation: 0,
        ),
        backgroundColor: dark
            ? const Color.fromARGB(255, 14, 14, 22)
            : const Color.fromARGB(255, 240, 234, 234),
        body: SizedBox(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ClockWidget(),
    
              FloatingSearchBar(
                builder: (context, transition) {
                  if (SharedPreferenceUtil.getBool('isLoggedIn') == false) {
                    return MyToast.show('Ops, You are not logged in yet!');
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const Material(color: Colors.white, elevation: 4.0),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      AvatarGlow(
                        endRadius: 90,
                        duration: const Duration(seconds: 2),
                        glowColor: Colors.white24,
                        repeat: true,
                        repeatPauseDuration: const Duration(seconds: 2),
                        startDelay: const Duration(seconds: 1),
                        child: Material(
                            elevation: 8.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(
                                  "https://media-exp1.licdn.com/dms/image/C560BAQEa3G_zhwPQZQ/company-logo_200_200/0/1599450429281?e=2159024400&v=beta&t=03_Soy5i8q-VjtKNpm93FVZJ7sr7cQ7aP3vjqmOeZOE"),
                              radius: 200.0,
                            )),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      DelayedAnimation(
                        child: Text(
                            "Hi ${SharedPreferenceUtil.getString('name')!.capitalize()}!",
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                                fontSize: 35.0,
                                color: color)),
                        delay: delayedAmount + 500,
                      ),
                      DelayedAnimation(
                        child: Text(
                          "Welcome Back!",
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.bold,
                              fontSize: 35.0,
                              color: color),
                        ),
                        delay: delayedAmount + 1000,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      DelayedAnimation(
                        child: Text(
                          "Your Last Login Time: ${SharedPreferenceUtil.getString('last_login_date')}",
                          style: GoogleFonts.ubuntu(
                              fontSize: 20.0,
                              color: color,
                              fontWeight: FontWeight.bold),
                        ),
                        delay: delayedAmount + 1500,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      DelayedAnimation(
                        child: Text(
                          DateFormat("yyyy-MM-dd, EEE | ")
                                  .format(DateTime.now()) +
                              "${weekNumber(DateTime.now())} week"
                              ,
                          style: GoogleFonts.ubuntu(
                              fontSize: 20.0,
                              color: color,
                              fontWeight: FontWeight.bold),
                        ),
                        delay: delayedAmount + 2000,
                      ),
                      const SizedBox(
                        height: 60.0,
                      ),
                      DelayedAnimation(
                        child: Text(
                          "Today, Kajin is in office",
                          style: GoogleFonts.ubuntu(fontSize: 20.0, color: color),
                        ),
                        delay: delayedAmount + 2500,
                      ),
                      const SizedBox(
                        height: 60.0,
                      ),
                      DelayedAnimation(
                        child: Text(
                          "This week, Kajin is oncall",
                          style: GoogleFonts.ubuntu(fontSize: 20.0, color: color),
                        ),
                        delay: delayedAmount + 3000,
                      ),
                      const SizedBox(
                        height: 100.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              dark = !dark;
              color = dark
                  ? const Color.fromARGB(255, 240, 234, 234)
                  : const Color.fromARGB(255, 14, 14, 22);
              SharedPreferenceUtil.setBool('dark_mode', dark);
            });
          },
          child: Icon(dark ? Icons.light_mode : Icons.dark_mode),
        ),
        drawer: const LeftSideBar(),
      ),
    );
  }
}

Widget buildFloatingSearchBar() {
  return FloatingSearchBar(
    hint: 'Search...',
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: -1.0,
    openAxisAlignment: 0.0,
    width: 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) {
      // Call your model, bloc, controller here.
    },
    // Specify a custom transition to be used for
    // animating between opened and closed stated.
    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.place),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ],
    builder: (context, transition) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.white,
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: Colors.accents.map((color) {
              return Container(height: 112, color: color);
            }).toList(),
          ),
        ),
      );
    },
  );
}
