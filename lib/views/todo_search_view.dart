import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../utils/constant.dart';
import 'package:flutter/material.dart';

import 'package:hanshow_project_google_sheets/models/todo_model.dart';

import '../models/todo_model.dart';
import 'package:search_choices/search_choices.dart';

class TodoSearchView extends StatefulWidget {
  const TodoSearchView({Key? key}) : super(key: key);

  @override
  _TodoSearchViewState createState() => _TodoSearchViewState();
}

class _TodoSearchViewState extends State<TodoSearchView> {
  final todo = TodoManager();

  String? valueType;
  String? valueContent;
  Future<List> getColumnData() async {
    List res = await todo.getColumnName()!;
    res.remove('No');
    return res;
  }

  Future<List<Todo>> getRowData(type) async {
    var res = await todo.getAll()!;

    return res;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //cancel the timer
    super.dispose();
  }

  late Map<String, double> columnWidths = {
    'Client': double.nan,
    'ID': double.nan,
    'Project Name': double.nan,
    'Address': double.nan,
    'Qty': double.nan,
    'Service Type': double.nan,
    'Complete Date': double.nan,
    'Due Date': double.nan,
    'Project Manager': double.nan,
    'Server IP': double.nan,
    'Start Date': double.nan,
    'Status': double.nan,
    'Task Owner': double.nan,
    'Chrono Status': double.nan,
    'Date Chronopost': double.nan,
    'Number Chronopost': double.nan,
    'Remarks': double.nan,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Search Data"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //position
        mainAxisSize: MainAxisSize.min,
        // wrap content in flutter
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              !kIsWeb &&Platform.isAndroid
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => {
                            Get.offAndToNamed('/todo', arguments: {
                              'type': 'Status',
                              'content': 'Not Started',
                              'filter': 'todo'
                            })
                            // Get.offAndToNamed(page)
                          },
                          icon: const Icon(Icons.today_outlined),
                        ),
                        const Text(
                          "To do",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    )
                  : TextButton(
                      onPressed: () => {
                        Get.offAndToNamed('/todo', arguments: {
                          'type': 'Status',
                          'content': 'Not Started',
                          'filter': 'todo'
                        })
                        // Get.offAndToNamed(page)
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.today_outlined,
                            semanticLabel: "To do",
                          ),
                          Text(
                            'To Do',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
              !kIsWeb &&Platform.isAndroid
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => {
                            Get.offAndToNamed('/todo', arguments: {
                              'type': 'Status',
                              'content': 'Complete',
                              'filter': 'complete'
                            })
                            // Get.offAndToNamed(page)
                          },
                          icon: const Icon(Icons.today_outlined),
                        ),
                        const Text(
                          "Complete",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    )
                  : TextButton(
                      onPressed: () => {
                        Get.offAndToNamed('/todo', arguments: {
                          'type': 'Status',
                          'content': 'Complete',
                          'filter': 'complete'
                        })
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.done_all,
                            semanticLabel: "Complete",
                          ),
                          Text(
                            'Complete',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
              !kIsWeb &&Platform.isAndroid
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => {
                            Get.offAndToNamed('/todo', arguments: {
                              'type': 'Chrono Status',
                              'content': 'Need Chrono',
                              'filter': 'needchrono'
                            })
                            // Get.offAndToNamed(page)
                          },
                          icon: const Icon(Icons.today_outlined),
                        ),
                        const Text(
                          "Need Chrono",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    )
                  : TextButton(
                      onPressed: () => {
                        Get.offAndToNamed('/todo', arguments: {
                          'type': 'Chrono Status',
                          'content': 'Need Chrono',
                          'filter': 'needchrono'
                        })
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.car_rental_rounded,
                            semanticLabel: "Need Chrono",
                          ),
                          Text('Need Chrono'),
                        ],
                      ),
                    ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<List>(
              future: getColumnData(),
              builder: (context, snapshot) {
                // ???????????????
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // ???????????????????????????
                    return Text("Error: ${snapshot.error}");
                  } else {
                    // ???????????????????????????
                    List<DropdownMenuItem> columnName = [];
                    for (var name in snapshot.data!) {
                      columnName.add(DropdownMenuItem(
                        child: Text(name),
                        value: name,
                      ));
                    }
                    return SearchChoices.single(
                      items: columnName,
                      value: valueType,
                      hint: "Search for",
                      searchHint: "Select one",
                      onChanged: (value) {
                        setState(() {
                          valueType = value;
                        });
                      },
                      isExpanded: true,
                    );
                  }
                } else {
                  // ????????????????????????loading
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
            height: 15,
          ),
          FutureBuilder<List<Todo>>(
              future: getRowData(valueType),
              builder: (context, snapshot) {
                // ???????????????
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // ???????????????????????????
                    return Text("Error: ${snapshot.error}");
                  } else {
                    // ???????????????????????????
                    List<DropdownMenuItem> rowData = [];
                    List res = [];
                    // var res = snapshot.data!;
                    for (var row in snapshot.data!) {
                      if (valueType != null) {
                        if (valueType!.contains('Date')) {
                          res.add(dateValidate(row.toGsheets()[valueType]));
                        } else {
                          res.add(row.toGsheets()[valueType].toString());
                        }
                      }
                    }
                    res = [
                      ...{...res}
                    ].reversed.toList();
                    res.remove('');
                    for (var row in res) {
                      rowData.add(DropdownMenuItem(
                        child: Text(
                          row,
                          overflow: TextOverflow.ellipsis,
                        ),
                        value: row,
                      ));
                    }

                    return SearchChoices.single(
                      readOnly: valueType == null ? true : false,
                      items: rowData,
                      value: valueContent,
                      hint: "Select one",
                      searchHint: "Select one",
                      onChanged: (value) {
                        setState(() {
                          valueContent = value;
                        });
                      },
                      isExpanded: true,
                    );
                  }
                } else {
                  // ????????????????????????loading
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
            height: 15,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL')),
        TextButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/todo',
                  arguments: {'type': valueType, 'content': valueContent});
            },
            child: const Text('CONFIRM')),
      ],
    );
  }
}
