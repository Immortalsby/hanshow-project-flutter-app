import 'dart:async';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:hanshow_project_google_sheets/models/todo_model.dart';
import 'package:hanshow_project_google_sheets/views/left_sidebar.dart';
import 'package:intl/intl.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import '../widgets/my_toast.dart';
import '../utils/shared_preferences_util.dart';
import 'package:flutter/services.dart';
import '../utils/constant.dart';
import '../models/todo_model.dart';
import '../models/add_history.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TodoView extends StatefulWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final todo = TodoManager();
  StreamController<List> streamController = StreamController();
  late TodoDataSource todoDataSource;

  Future getData() async {
    var data = await todo.getAll();
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
  // final ScrollController horizontalScroll = ScrollController();
  // final ScrollController verticalScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (SharedPreferenceUtil.getBool('isLoggedIn') == false) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Todo Members"),
            elevation: 0,
          ),
          body: MyToast.show('Ops, You are not logged in yet!'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Members"),
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
                todoDataSource =
                    TodoDataSource(toDoData: snapshot.data!.cast<Todo>());
                print(snapshot.data![0].toString());
                print(DateTime.tryParse("2022-01-12"));
                return SfDataGrid(
                  source: todoDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'ID',
                        label: Container(
                            padding: EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            child: Text(
                              'ID',
                            ))),
                    GridColumn(
                        columnName: 'Service Type',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Service TypeClient'))),
                    GridColumn(
                        columnName: 'Client',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Client',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'Project Name',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Project Name'))),
                    GridColumn(
                        columnName: 'Address',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Address'))),
                    GridColumn(
                        columnName: 'Qty',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Qty'))),
                    GridColumn(
                        columnName: 'Server IP',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Server IP'))),
                    GridColumn(
                        columnName: 'Project Manager',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Project Manager'))),
                    GridColumn(
                        columnName: 'Status',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Status'))),
                    GridColumn(
                        columnName: 'Start Date',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Start Date'))),
                    GridColumn(
                        columnName: 'Due Date',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Due Date'))),
                    GridColumn(
                        columnName: 'Complete Date',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Complete Date'))),
                    GridColumn(
                        columnName: 'Task Owner',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Task Owner'))),
                    GridColumn(
                        columnName: 'Chrono Status',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Chrono Status'))),
                    GridColumn(
                        columnName: 'Date Chronopost',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Date Chronopost'))),
                    GridColumn(
                        columnName: 'Number Chronopost',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Number Chronopost'))),
                    GridColumn(
                        columnName: 'Remarks',
                        label: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: Text('Remarks'))),
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

//Click menu Add

  final TextEditingController _editController = TextEditingController();

//   clickShowMenu(item, context, details, String type, row, column) {
//     showMenu(
//         context: context,
//         position: RelativeRect.fromLTRB(
//           details.globalPosition.dx,
//           details.globalPosition.dy,
//           details.globalPosition.dx,
//           details.globalPosition.dy,
//         ),
//         items: <PopupMenuEntry>[
//           PopupMenuItem<String>(
//             value: 'edit',
//             child: const Text('Edit'),
//             onTap: () {
//               Future.delayed(
//                   const Duration(seconds: 0),
//                   () => showDialog(
//                       context: context,
//                       builder: (context) {
//                         _editController.text = item;
//                         return AlertDialog(
//                           title: Text("Editing For ${type.capitalize()}"),
//                           content: TextField(
//                             onChanged: (value) {},
//                             controller: _editController,
//                             onEditingComplete: () {
//                               Future.delayed(const Duration(seconds: 0),
//                                   () async {
//                                 bool res = await TodoManager()
//                                     .insert(row, column, _editController.text);
//                                 Navigator.pop(context);
//                                 MyToast.show(res ? 'Success!' : 'Failed');
//                                 setState(() {
//                                   getData();
//                                 });
//                               });
//                             },
//                           ),
//                           actions: <Widget>[
//                             TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: const Text('CANCEL')),
//                             TextButton(
//                                 onPressed: () {
//                                   Future.delayed(const Duration(seconds: 0),
//                                       () async {
//                                     bool res = await TodoManager().insert(
//                                         row, column, _editController.text);
//                                     Navigator.pop(context);
//                                     MyToast.show(res ? 'Success!' : 'Failed');
//                                     setState(() {
//                                       AddHistory().add(
//                                           SharedPreferenceUtil.getString(
//                                               'name'),
//                                           item,
//                                           _editController.text,
//                                           'Todo',
//                                           row,
//                                           column);
//                                       getData();
//                                     });
//                                   });
//                                 },
//                                 child: const Text('CONFIRM')),
//                           ],
//                         );
//                       }));
//             },
//           ),
//           PopupMenuItem<String>(
//             value: item,
//             child: Text(item == "" ? "No Data" : "Copy '$item'"),
//             onTap: () {
//               if (item != "") {
//                 Clipboard.setData(ClipboardData(text: item));
//                 MyToast.show('Copied to clipboard!');
//               }
//             },
//           )
//         ]);
//   }
}

class TodoDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  TodoDataSource({required List<Todo> toDoData}) {
    _toDoData = toDoData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'ID', value: e.id),
              DataGridCell<String>(
                  columnName: 'Service Type', value: e.serviceType),
              DataGridCell<String>(columnName: 'Client', value: e.client),
              DataGridCell<String>(columnName: 'Project Name', value: e.client),
              DataGridCell<String>(columnName: 'Address', value: e.address),
              DataGridCell<int>(columnName: 'Qty', value: e.qty),
              DataGridCell<String>(columnName: 'Server IP', value: e.serverIp),
              DataGridCell<String>(
                  columnName: 'Project Manager', value: e.projectManager),
              DataGridCell<String>(columnName: 'Status', value: e.status),
              DataGridCell<DateTime>(
                  columnName: 'Start Date', value: e.startDate),
              DataGridCell<DateTime>(columnName: 'Due Date', value: e.dueDate),
              DataGridCell<DateTime>(
                  columnName: 'Complete Date', value: e.completeDate),
              DataGridCell<String>(columnName: 'Task Owner', value: e.taskOwner),
              DataGridCell<String>(
                  columnName: 'Chrono Status', value: e.chronoStatus),
              DataGridCell<DateTime>(
                  columnName: 'Date Chronopost', value: e.dateChronapost),
              DataGridCell<String>(
                  columnName: 'Number Chronopost', value: e.numberChronopost),
              DataGridCell<String>(columnName: 'Remarks', value: e.remarks),
            ]))
        .toList();
  }

  List<DataGridRow> _toDoData = [];

  @override
  List<DataGridRow> get rows => _toDoData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
