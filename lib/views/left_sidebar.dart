import 'package:flutter/material.dart';
import '../config/shared_preferences_util.dart';
import '../config/constant.dart';
import 'change_password.dart';

class LeftSideBar extends StatelessWidget {
  const LeftSideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);
    String _path = '/';
    if (route != null) {
      // ignore: avoid_print
      print(route.settings.name);
      _path = route.settings.name!;
    }
    return Drawer(
        child: ListView(
          controller: ScrollController(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              // ignore: unnecessary_const
              child: UserAccountsDrawerHeader(
                currentAccountPictureSize: const Size(60, 60),
                accountName: Text(
                    SharedPreferenceUtil.getString('name')!.capitalize(),
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                accountEmail: Text(SharedPreferenceUtil.getString('email')!,
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
                //账户头像
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/46.jpg"),
                ),

                //配置背景
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/layout.jpg'))),

                //配置其他
                otherAccountsPictures: <Widget>[
                  IconButton(
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
                    icon: const Icon(Icons.password, color: Colors.white70,),
                    tooltip: 'Change Password',
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/login');
                      SharedPreferenceUtil.setBool("isLoggedIn", false);
                    },
                    icon: const Icon(Icons.logout, color: Colors.white70,),
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
                leading:const Icon(Icons.home ,color: Colors.black,),
                
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
                title: const Text('Team Member',
                    ),
                leading:  const Icon(Icons.people, color: Colors.black,),
                onTap: () {
                  if (_path != '/team') {
                    Navigator.popAndPushNamed(context, '/team');
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('History'),
              leading: const Icon(Icons.history),
              
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }
}
