import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hanshow_project_google_sheets/config/config.dart';
import '../utils/shared_preferences_util.dart';
import '../utils/constant.dart';
import 'change_password_view.dart';
import 'package:url_launcher/url_launcher.dart';

class LeftSideBar extends StatelessWidget {
  const LeftSideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);
    String _path = '/';
    if (route != null) {
      _path = route.settings.name!;
    }
    return Drawer(
        child: Column(
      children: [
        Expanded(
          child: ListView(
            controller: ScrollController(),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: UserAccountsDrawerHeader(
                  currentAccountPictureSize: const Size(60, 60),
                  accountName: Text(
                      SharedPreferenceUtil.getString('name')!.capitalize(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)),
                  accountEmail: Text(SharedPreferenceUtil.getString('email')!,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)),
                  //账户头像
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        SharedPreferenceUtil.getString('avator_url') ?? ''),
                  ),

                  //配置背景
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/layout.jpg'))),

                  //配置其他
                  otherAccountsPictures: <Widget>[
                    kIsWeb
                        ? const Text('')
                        : IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // SharedPreferenceUtil.setBool("isLoggedIn", false);
                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const ChangePasswordView();
                                      }));
                            },
                            icon: const Icon(
                              Icons.password,
                              color: Colors.white70,
                            ),
                            tooltip: 'Change Password',
                          ),
                    IconButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/login');
                        SharedPreferenceUtil.setBool("isLoggedIn", false);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white70,
                      ),
                      tooltip: 'Log Out',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  title: const Text('Home Page'),
                  //CircleAvatar 一般用于设置圆形头像
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),

                  onTap: () {
                    if (_path != '/home') {
                      Navigator.popAndPushNamed(context, '/home');
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  title: const Text('To-Do List'),
                  leading: const Icon(
                    Icons.list,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/todo');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  title: const Text('Action Plan'),
                  leading: const Icon(
                    Icons.alarm,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.popAndPushNamed(context, '/action');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  title: const Text(
                    'Team Member',
                  ),
                  leading: const Icon(
                    Icons.people,
                    color: Colors.black,
                  ),
                  onTap: () {
                    if (_path != '/team') {
                      Navigator.popAndPushNamed(context, '/team');
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  title: const Text('History'),
                  leading: const Icon(
                    Icons.history,
                    color: Colors.black,
                  ),
                  onTap: () {
                    if (_path != '/history') {
                      Navigator.popAndPushNamed(context, '/history');
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: ListTile(
            title: const Text(
              "VERSION:  $version",
              style: TextStyle(fontSize: 11),
            ),
            onTap: () {
              Navigator.pop(context);
              // SharedPreferenceUtil.setBool("isLoggedIn", false);
              Future.delayed(
                  const Duration(seconds: 0),
                  () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Hi, you found a easter egg!'),
                          content: const Text(
                              '''I made this project open source and kept Hanshow's information confidential! If you are interested, you can go to my github to see the source code'''),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('No, thanks 💔')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _launchURL();
                                },
                                child: const Text('I\'d love to 🌹')),
                          ],
                        );
                      }));
            },
          ),
        ),
      ],
    ));
  }

  _launchURL() async {
    const _url = 'https://github.com/Immortalsby/hanshow-project-flutter-app';
    if (!await launch(_url)) throw 'Could not launch $_url';
  }
}
