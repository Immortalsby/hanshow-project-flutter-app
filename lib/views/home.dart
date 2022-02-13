import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanshow_project_google_sheets/views/left_sidebar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:intl/intl.dart';
import '../utils/shared_preferences_util.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'change_password_view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/work_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var dark = true;
  var onCall = "no one";
  List<Work>? _work = [];
  var color = const Color.fromARGB(255, 240, 234, 234);
  final int delayedAmount = 500;
  late _DataSource _dataSource;
  final workManager = WorkManager();

  Future getData() async {
    _work = await workManager.getAll();
    _dataSource = _getDataSource();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (SharedPreferenceUtil.getBool('isLoggedIn') == false) {
        navService.pushNamed('/login', args: 'Your are not logged in');
      }
    });

    getData();

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
    super.initState();
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
    _launchURL(platform) async {
      var _url = platform == 'windows'
          ? 'https://hanshow.eu/download/hanshow_project_x64.exe'
          : 'https://hanshow.eu/download/hanshow_project.apk';
      if (!await launch(_url)) throw 'Could not launch $_url';
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Hanshow Project"),
          elevation: 0,
          actions: [
            kIsWeb
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Download APP",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              //设置按下时的背景颜色
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.blue[200];
                              }
                              //默认不使用背景颜色
                              return const Color.fromARGB(255, 6, 53, 92);
                            }),
                          ),
                          onPressed: () => {_launchURL('windows')},
                          child: Row(
                            children: const [
                              Icon(Icons.desktop_windows),
                              Text("   Windows"),
                            ],
                          )),
                      const Text(""),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            //设置按下时的背景颜色
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.blue[200];
                            }
                            //默认不使用背景颜色
                            return const Color.fromARGB(255, 6, 53, 92);
                          }),
                        ),
                        onPressed: () => {_launchURL('android')},
                        child: Row(
                          children: const [
                            Icon(Icons.android),
                            Text("   Android"),
                          ],
                        ),
                      )
                    ],
                  )
                : const Text(""),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        backgroundColor: dark
            ? const Color.fromARGB(255, 14, 14, 22)
            : const Color.fromARGB(255, 240, 234, 234),
        body: SizedBox(
          child: Stack(
            fit: StackFit.expand,
            children: [
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
                      Text(
                          "Hi ${SharedPreferenceUtil.getString('name')!.capitalize}!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.bold,
                              fontSize: 35.0,
                              color: color)),
                      Text(
                        "Welcome Back!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            color: color),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Your Last Login Time: ${SharedPreferenceUtil.getString('last_login_date')}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                            fontSize: 20.0,
                            color: color,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        DateFormat("yyyy-MM-dd, EEE | ")
                                .format(DateTime.now()) +
                            "${weekNumber(DateTime.now())} week",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                            fontSize: 20.0,
                            color: color,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 60.0,
                      ),
                      FutureBuilder(
                          future: getData(),
                          builder: (context, snapshot) {
                            // 请求已结束
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                // 请求失败，显示错误
                                return Text("Error: ${snapshot.error}");
                              } else {
                                return Text(
                                  "This week, $onCall is oncall",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 20.0, color: color),
                                );
                              }
                            } else {
                              // 请求未结束，显示loading
                              return const SizedBox(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          }),
                      const SizedBox(
                        height: 100.0,
                      ),
                      SizedBox(
                        height: 1000,
                        width: 1000,
                        child: FutureBuilder(
                            future: getData(),
                            builder: (context, snapshot) {
                              // 请求已结束
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  // 请求失败，显示错误
                                  return Text("Error: ${snapshot.error}");
                                } else {
                                  return SfCalendar(
                                    view: CalendarView.schedule,
                                    showWeekNumber: true,
                                    scheduleViewSettings: ScheduleViewSettings(
                                        appointmentItemHeight: 100,
                                        hideEmptyScheduleWeek: true,
                                        dayHeaderSettings:
                                            const DayHeaderSettings(
                                                // dayFormat: 'EE',
                                                width: 140,
                                                dayTextStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red,
                                                ),
                                                dateTextStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.red,
                                                )),
                                        appointmentTextStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: color)),
                                    dataSource: _dataSource,
                                  );
                                }
                              } else {
                                // 请求未结束，显示loading
                                return const SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            }),
                      ),
                      const SizedBox(
                        height: 60.0,
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

  _DataSource _getDataSource() {
    List week = [
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];
    List inOfficeMonday = [];
    List inOfficeTuesday = [];
    List inOfficeWednesday = [];
    List inOfficeThursday = [];
    List inOfficeFriday = [];
    List vacationMonday = [];
    List vacationTuesday = [];
    List vacationWednesday = [];
    List vacationThursday = [];
    List vacationFriday = [];

    String today = DateFormat("EEEE").format(DateTime.now());
    for (var mem in _work!) {
      if (week.indexOf(today) <= week.indexOf('Monday')) {
        if (mem.monday == 'Bureau') {
          inOfficeMonday.add(mem.name);
        } else if (mem.monday == 'Congé') {
          vacationMonday.add(mem.name);
        }
      }
      if (week.indexOf(today) <= week.indexOf('Tuesday')) {
        if (mem.tuesday == 'Bureau') {
          inOfficeTuesday.add(mem.name);
        } else if (mem.tuesday == 'Congé') {
          vacationTuesday.add(mem.name);
        }
      }
      if (week.indexOf(today) <= week.indexOf('Wednesday')) {
        if (mem.wednesday == 'Bureau') {
          inOfficeWednesday.add(mem.name);
        } else if (mem.wednesday == 'Congé') {
          vacationWednesday.add(mem.name);
        }
      }
      if (week.indexOf(today) <= week.indexOf('Thursday')) {
        if (mem.thursday == 'Bureau') {
          inOfficeThursday.add(mem.name);
        } else if (mem.thursday == 'Congé') {
          vacationThursday.add(mem.name);
        }
      }
      if (week.indexOf(today) <= week.indexOf('Friday')) {
        if (mem.friday == 'Bureau') {
          inOfficeFriday.add(mem.name);
        } else if (mem.friday == 'Congé') {
          vacationFriday.add(mem.name);
        }
      }
      if (mem.oncall == 'Yes') {
        onCall = mem.name!;
      }
    }
    final List<Appointment> appointments = <Appointment>[];
    if (vacationMonday.isNotEmpty || inOfficeMonday.isNotEmpty) {
      appointments.add(Appointment(
          startTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Monday') - week.indexOf(today))),
          endTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Monday') - week.indexOf(today))),
          subject: inOfficeMonday.isEmpty
              ? "No one in office"
              : "Office: ${inOfficeMonday.join(',')}",
          color: Colors.lightBlueAccent,
          isAllDay: true));
      appointments.add(Appointment(
          startTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Monday') - week.indexOf(today))),
          endTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Monday') - week.indexOf(today))),
          subject: vacationMonday.isEmpty
              ? "No one on leave"
              : "On leave: ${vacationMonday.join(',')}",
          color: const Color.fromARGB(255, 250, 187, 0),
          isAllDay: true));
    }

    if (vacationTuesday.isNotEmpty || inOfficeTuesday.isNotEmpty) {
      appointments.add(Appointment(
          startTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Tuesday') - week.indexOf(today))),
          endTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Tuesday') - week.indexOf(today))),
          subject: inOfficeTuesday.isEmpty
              ? "No one in office"
              : "Office: ${inOfficeTuesday.join(',')}",
          color: Colors.lightBlueAccent,
          isAllDay: true));
      appointments.add(Appointment(
          startTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Tuesday') - week.indexOf(today))),
          endTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Tuesday') - week.indexOf(today))),
          subject: vacationTuesday.isEmpty
              ? "No one on leave"
              : "On leave: ${vacationTuesday.join(',')}",
          color: const Color.fromARGB(255, 250, 187, 0),
          isAllDay: true));
    }
    if (vacationWednesday.isNotEmpty || inOfficeWednesday.isNotEmpty) {
      appointments.add(Appointment(
          startTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Wednesday') - week.indexOf(today))),
          endTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Wednesday') - week.indexOf(today))),
          subject: inOfficeWednesday.isEmpty
              ? "No one in office"
              : "Office: ${inOfficeWednesday.join(',')}",
          color: Colors.lightBlueAccent,
          isAllDay: true));
      appointments.add(Appointment(
          startTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Wednesday') - week.indexOf(today))),
          endTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Wednesday') - week.indexOf(today))),
          subject: vacationWednesday.isEmpty
              ? "No one on leave"
              : "On leave: ${vacationWednesday.join(',')}",
          color: const Color.fromARGB(255, 250, 187, 0),
          isAllDay: true));
    }
    if (vacationThursday.isNotEmpty || inOfficeThursday.isNotEmpty) {
      appointments.add(Appointment(
          startTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Thursday') - week.indexOf(today))),
          endTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Thursday') - week.indexOf(today))),
          subject: inOfficeThursday.isEmpty
              ? "No one in office"
              : "Office: ${inOfficeThursday.join(',')}",
          color: Colors.lightBlueAccent,
          isAllDay: true));
      appointments.add(Appointment(
          startTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Thursday') - week.indexOf(today))),
          endTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Thursday') - week.indexOf(today))),
          subject: vacationThursday.isEmpty
              ? "No one on leave"
              : "On leave: ${vacationThursday.join(',')}",
          color: const Color.fromARGB(255, 250, 187, 0),
          isAllDay: true));
    }
    if (vacationFriday.isNotEmpty || inOfficeFriday.isNotEmpty) {
      appointments.add(Appointment(
          startTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Friday') - week.indexOf(today))),
          endTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Friday') - week.indexOf(today))),
          subject: inOfficeFriday.isEmpty
              ? "No one in office"
              : "Office: ${inOfficeFriday.join(',')}",
          color: Colors.lightBlueAccent,
          isAllDay: true));
      appointments.add(Appointment(
          startTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Friday') - week.indexOf(today))),
          endTime: DateTime.now().add(Duration(
              hours: 8, days: week.indexOf('Friday') - week.indexOf(today))),
          subject: vacationFriday.isEmpty
              ? "No one on leave"
              : "On leave: ${vacationFriday.join(',')}",
          color: const Color.fromARGB(255, 250, 187, 0),
          isAllDay: true));
    }

    return _DataSource(appointments);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class CreateData extends GetxController {}
