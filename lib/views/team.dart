import 'dart:async';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:hanshow_project_google_sheets/models/team.dart';
import 'package:hanshow_project_google_sheets/views/left_sidebar.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import '../widgets/my_toast.dart';
import '../config/shared_preferences_util.dart';
import 'package:flutter/services.dart';
import '../config/constant.dart';
import '../models/team.dart';
import '../models/add_history.dart';

class Team extends StatefulWidget {
  const Team({Key? key}) : super(key: key);

  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  final team = TeamManager();
  StreamController<List> streamController = StreamController();

  Future getData() async {
    var data = await team.getAll();
    streamController.add(data!);
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

  final int _currentSortColumn = 0;
  final bool _isAscending = true;
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (SharedPreferenceUtil.getBool('isLoggedIn') == false) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Team Members"),
            elevation: 0,
          ),
          body: MyToast.show('Ops, You are not logged in yet!'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Members"),
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
                return AdaptiveScrollbar(
                  controller: verticalScroll,
                  width: 20,
                  child: AdaptiveScrollbar(
                    controller: horizontalScroll,
                    width: 20,
                    position: ScrollbarPosition.bottom,
                    underSpacing: const EdgeInsets.only(bottom: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        controller: horizontalScroll,
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DataTable(
                            sortColumnIndex: _currentSortColumn,
                            sortAscending: _isAscending,
                            border: TableBorder.all(
                              width: 2.0,
                              color: const Color.fromARGB(255, 255, 228, 148),
                            ),
                            headingRowColor:
                                MaterialStateProperty.all(Colors.amber[200]),
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Role')),
                              DataColumn(label: Text('Team')),
                              DataColumn(label: Text('Gmail')),
                            ],
                            rows: snapshot.data!.asMap().entries.map((entry) {
                              int index = entry.key;
                              var item = entry.value;
                              return DataRow(cells: [
                                DataCell(GestureDetector(
                                    child: SizedBox(
                                      child: Text(item.name),
                                      width: double.infinity,
                                    ),
                                    onTapUp: (details) {
                                      clickShowMenu(item.name, context, details,
                                          'name', index, 0);
                                    })),
                                DataCell(GestureDetector(
                                    child: SizedBox(
                                      child: Text(item.email),
                                      width: double.infinity,
                                    ),
                                    onTapUp: (details) {
                                      clickShowMenu(item.email, context,
                                          details, 'email', index, 1);
                                    })),
                                DataCell(GestureDetector(
                                    child: SizedBox(
                                      child: Text(item.role),
                                      width: double.infinity,
                                    ),
                                    onTapUp: (details) {
                                      clickShowMenu(item.role, context, details,
                                          'role', index, 2);
                                    })),
                                DataCell(GestureDetector(
                                    child: SizedBox(
                                      child: Text(item.team),
                                      width: double.infinity,
                                    ),
                                    onTapUp: (details) {
                                      setState(() {
                                        clickShowMenu(item.team, context,
                                            details, 'team', index, 3);
                                      });
                                    })),
                                DataCell(GestureDetector(
                                    child: SizedBox(
                                      child: Text(item.gmail),
                                      width: double.infinity,
                                    ),
                                    onTapUp: (details) {
                                      setState(() {
                                        clickShowMenu(item.gmail, context,
                                            details, 'gmail', index, 4);
                                      });
                                    }))
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const Text("Loading...");
              }
            }),
      ),
      drawer: const LeftSideBar(),
    );
  }

//Click menu Add

  final TextEditingController _editController = TextEditingController();

  clickShowMenu(item, context, details, String type, row, column) {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ),
        items: <PopupMenuEntry>[
          PopupMenuItem<String>(
            value: 'edit',
            child: const Text('Edit'),
            onTap: () {
              Future.delayed(
                  const Duration(seconds: 0),
                  () => showDialog(
                      context: context,
                      builder: (context) {
                        _editController.text = item;
                        return AlertDialog(
                          title: Text("Editing For ${type.capitalize()}"),
                          content: TextField(
                            onChanged: (value) {},
                            controller: _editController,
                            onEditingComplete: () {
                              Future.delayed(const Duration(seconds: 0),
                                  () async {
                                bool res = await TeamManager()
                                    .insert(row, column, _editController.text);
                                Navigator.pop(context);
                                MyToast.show(res ? 'Success!' : 'Failed');
                                setState(() {
                                  getData();
                                });
                              });
                            },
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('CANCEL')),
                            TextButton(
                                onPressed: () {
                                  Future.delayed(const Duration(seconds: 0),
                                      () async {
                                    bool res = await TeamManager().insert(
                                        row, column, _editController.text);
                                    Navigator.pop(context);
                                    MyToast.show(res ? 'Success!' : 'Failed');
                                    setState(() {
                                      AddHistory().add(
                                          SharedPreferenceUtil.getString(
                                              'name'),
                                          item,
                                          _editController.text,
                                          'Team',
                                          row,
                                          column);
                                      getData();
                                    });
                                  });
                                },
                                child: const Text('CONFIRM')),
                          ],
                        );
                      }));
            },
          ),
          PopupMenuItem<String>(
            value: item,
            child: Text(item == "" ? "No Data" : "Copy '$item'"),
            onTap: () {
              if (item != "") {
                Clipboard.setData(ClipboardData(text: item));
                MyToast.show('Copied to clipboard!');
              }
            },
          )
        ]);
  }
}
