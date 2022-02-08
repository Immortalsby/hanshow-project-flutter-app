import 'dart:async';

import 'package:flutter/material.dart';
import '../models/get_history.dart';
import '../utils/shared_preferences_util.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import '../widgets/my_toast.dart';
import '../views/left_sidebar.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import '../utils/constant.dart';
import 'package:pretty_diff_text/pretty_diff_text.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  // final team = HistoryManager();
  StreamController<List> streamController = StreamController();

  Future getData() async {
    var data = await GetHistory().all();
    streamController.add(data);
  }

  @override
  void initState() {
    getData();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (SharedPreferenceUtil.getBool('isLoggedIn') == false) {
        navService.pushNamed('/login', args: 'Your are not logged in');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    //cancel the timer
    super.dispose();
  }

  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (SharedPreferenceUtil.getBool('isLoggedIn') == false) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("History"),
            elevation: 0,
          ),
          body: MyToast.show('Ops, You are not logged in yet!'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh Data',
                onPressed: () {
                  setState(() {
                    getData();
                  });
                },
              )),
        ],
        elevation: 0,
      ),
      body: SizedBox(
        child: StreamBuilder<List>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    // Text(snapshot.data!.toString()),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: GroupedListView<dynamic, String>(
                        elements: snapshot.data!,
                        order: GroupedListOrder.ASC,
                        floatingHeader: true,
                        useStickyGroupSeparators: true,
                        groupBy: (data) =>
                            DateFormat.yMMMd().format(data['modify_date']),
                        groupHeaderBuilder: (data) => SizedBox(
                          height: 40,
                          child: Align(
                            child: Container(
                              width: 160,
                              decoration: const BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat.yMMMEd()
                                      .format(data['modify_date']),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        itemBuilder: (_, data) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.95,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                elevation: 8.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: InkWell(
                                  onTap: () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Modify records for ${data['target_sheet']}(${data['position']}) "),
                                          content: SingleChildScrollView(
                                            child: PrettyDiffText(
                                              defaultTextStyle: const TextStyle(fontFamily: "Poppins", fontSize: 18, color: Colors.black),
                                              oldText: data['original_data'],
                                              newText: data['new_data'],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('OK')),
                                          ],
                                        );
                                      }),
                                  mouseCursor: MouseCursor.defer,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    leading: const Icon(Icons.person),
                                    title: RichText(
                                        text: TextSpan(
                                            text: data['username']
                                                .toString()
                                                .capitalize(),
                                            style: const TextStyle(
                                                color: Colors.blueAccent, fontSize: 16),
                                            children: [
                                          const TextSpan(
                                            text: ' Has Changed ',
                                            style:
                                                TextStyle(color: Colors.black, fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: data['position'],
                                            style: const TextStyle(
                                                color: Colors.redAccent, fontSize: 16),
                                          ),
                                          const TextSpan(
                                            text: ' in ',
                                            style:
                                                TextStyle(color: Colors.black, fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: data['target_sheet'],
                                            style: const TextStyle(
                                                color: Colors.deepOrangeAccent, fontSize: 16),
                                          )
                                        ])),
                                    trailing: Text(DateFormat.Hm()
                                        .format(data['modify_date'])),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Text("Loading...");
              }
            }),
      ),
      drawer: const LeftSideBar(),
    );
  }
}