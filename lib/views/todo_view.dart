import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hanshow_project_google_sheets/models/todo_model.dart';
import 'package:hanshow_project_google_sheets/views/left_sidebar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../utils/constant.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import '../widgets/my_toast.dart';
import '../utils/shared_preferences_util.dart';
import '../models/todo_model.dart';
import '../models/add_history.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'todo_search_view.dart';
import 'package:get/get.dart';
import 'package:search_choices/search_choices.dart';
import 'package:searchfield/searchfield.dart';

class TodoView extends StatefulWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  _TodoViewState createState() => _TodoViewState();
}

final todo = TodoManager();
final todoConfig = TodoConfigManager();
List columnData = [];
List<TodoConfig> listTodoConfig = [];
List configData = [];
dynamic args;

class _TodoViewState extends State<TodoView> {
  StreamController<List> streamController = StreamController();
  late TodoDataSource todoDataSource;

  Future getData() async {
    var data = await todo.getAll();

    streamController.add(data!);
  }

  Future getConfigData() async {
    var data = await todoConfig.getAll();

    listTodoConfig = data!;
  }

  Future getColumnData() async {
    columnData = await todo.getColumnName()!;
  }

  Future getConfigColumn() async {
    configData = await todoConfig.getColumnName()!;
  }

  @override
  void initState() {
    getData();
    getColumnData();
    getConfigColumn();
    getConfigData();
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
  String? valueType;
  String? valueContent;

  late Map<String, double> columnWidths = {
    'No': double.nan,
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


    if (SharedPreferenceUtil.getBool('isLoggedIn') == false) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("To-Do List"),
            elevation: 0,
          ),
          body: MyToast.show('Ops, You are not logged in yet!'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
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
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasError) {
                  // 请求失败，显示错误
                  return Text("Error: ${snapshot.error}");
                } else {
                  todoDataSource = TodoDataSource(
                    toDoData: snapshot.data!.cast<Todo>(),
                    args: Get.arguments,
                  );
                  return SfDataGridTheme(
                    data: SfDataGridThemeData(
                        headerColor: Colors.amberAccent,
                        headerHoverColor: Colors.amber,
                        gridLineColor: Colors.amber,
                        gridLineStrokeWidth: 1.0),
                    child: SfDataGrid(
                      allowEditing: true,
                      allowTriStateSorting: true,
                      allowSorting: true,
                      allowMultiColumnSorting: true,
                      selectionMode: SelectionMode.single,
                      navigationMode: GridNavigationMode.cell,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      isScrollbarAlwaysShown: true,
                      frozenColumnsCount: Platform.isAndroid ? 2 : 5,
                      allowPullToRefresh: true,
                      source: todoDataSource,
                      // columnWidthMode: ColumnWidthMode.fitByCellValue,
                      columnResizeMode: ColumnResizeMode.onResizeEnd,
                      allowColumnsResizing: true,
                      onQueryRowHeight: (details) {
                        return details.getIntrinsicRowHeight(details.rowIndex);
                      },

                      onColumnResizeUpdate:
                          (ColumnResizeUpdateDetails details) {
                        setState(() {
                          columnWidths[details.column.columnName] =
                              details.width;
                        });
                        return true;
                      },
                      columns: <GridColumn>[
                        GridColumn(
                            allowEditing: false,
                            width: columnWidths['No']!,
                            visible: false,
                            columnName: 'No',
                            label: Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'No',
                                ))),
                        GridColumn(
                            width: columnWidths['ID']!,
                            minimumWidth: 100.0,
                            columnName: 'ID',
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'needchrono'
                                    ? false
                                    : true
                                : true,
                            label: Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'ID',
                                ))),
                        GridColumn(
                            width: columnWidths['Service Type']!,
                            minimumWidth: 100.0,
                            columnName: 'Service Type',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Service Type'))),
                        GridColumn(
                            width: columnWidths['Client']!,
                            minimumWidth: 100.0,
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'todo'
                                    ? false
                                    : true
                                : true,
                            columnName: 'Client',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Client'))),
                        GridColumn(
                            width: columnWidths['Project Name']!,
                            minimumWidth: 100.0,
                            columnName: 'Project Name',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Project Name'))),
                        GridColumn(
                            width: columnWidths['Address']!,
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            minimumWidth: 100.0,
                            columnName: 'Address',
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'todo'
                                    ? false
                                    : true
                                : true,
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Address'))),
                        GridColumn(
                            width: columnWidths['Qty']!,
                            minimumWidth: 100.0,
                            columnName: 'Qty',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Qty'))),
                        GridColumn(
                            width: columnWidths['Server IP']!,
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            minimumWidth: 100.0,
                            columnName: 'Server IP',
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'needchrono'
                                    ? false
                                    : true
                                : true,
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Server IP'))),
                        GridColumn(
                            width: columnWidths['Project Manager']!,
                            minimumWidth: 100.0,
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'todo'
                                    ? false
                                    : true
                                : true,
                            columnName: 'Project Manager',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Project Manager'))),
                        GridColumn(
                            width: columnWidths['Status']!,
                            minimumWidth: 100.0,
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'needchrono'
                                    ? false
                                    : true
                                : true,
                            columnName: 'Status',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Status'))),
                        GridColumn(
                            width: columnWidths['Start Date']!,
                            minimumWidth: 100.0,
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'todo'
                                    ? false
                                    : true
                                : true,
                            columnName: 'Start Date',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Start Date'))),
                        GridColumn(
                            width: columnWidths['Due Date']!,
                            minimumWidth: 100.0,
                            columnName: 'Due Date',
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'needchrono'
                                    ? false
                                    : true
                                : true,
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Due Date'))),
                        GridColumn(
                            width: columnWidths['Complete Date']!,
                            minimumWidth: 100.0,
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'todo'
                                    ? false
                                    : true
                                : true,
                            columnName: 'Complete Date',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Complete Date'))),
                        GridColumn(
                            width: columnWidths['Task Owner']!,
                            minimumWidth: 100.0,
                            columnName: 'Task Owner',
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'needchrono'
                                    ? false
                                    : true
                                : true,
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Task Owner'))),
                        GridColumn(
                            width: columnWidths['Chrono Status']!,
                            minimumWidth: 100.0,
                            columnName: 'Chrono Status',
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'todo'
                                    ? false
                                    : true
                                : true,
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Chrono Status'))),
                        GridColumn(
                            width: columnWidths['Date Chronopost']!,
                            minimumWidth: 100.0,
                            columnName: 'Date Chronopost',
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'todo'
                                    ? false
                                    : true
                                : true,
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Date Chronopost'))),
                        GridColumn(
                            width: columnWidths['Number Chronopost']!,
                            columnWidthMode: ColumnWidthMode.fitByCellValue,
                            minimumWidth: 100.0,
                            columnName: 'Number Chronopost',
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'todo'
                                    ? false
                                    : true
                                : true,
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Number Chronopost'))),
                        GridColumn(
                            width: columnWidths['Remarks']!,
                            minimumWidth: 100.0,
                            visible: Get.arguments != null
                                ? Get.arguments['filter'] == 'needchrono'
                                    ? false
                                    : true
                                : true,
                            columnName: 'Remarks',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Remarks'))),
                      ],
                    ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future.delayed(
              const Duration(seconds: 0),
              () async => args = await Get.to(showDialog(
                  context: context,
                  builder: (context) {
                    return const TodoSearchView();
                  })));
        },
        child: const Icon(Icons.search),
      ),
      drawer: const LeftSideBar(),
    );
  }
}

class TodoDataSource extends DataGridSource {
  /// Creates the todo data source
  TodoDataSource({required List<Todo> toDoData, args}) {
    if (args != null) {
      List<Todo> toDoDataFiltered = [];
      for (var todo in toDoData) {
        if (args['type'].toString().contains('Date')) {
          if (dateValidate(todo.toGsheets()[args['type'].toString()]) ==
              args['content'].toString()) toDoDataFiltered.add(todo);
        } else {
          if (todo.toGsheets()[args['type'].toString()].toString() ==
              args['content'].toString()) {
            toDoDataFiltered.add(todo);
          }
        }
      }
      toDoData = toDoDataFiltered;
    }

    _toDoData = toDoData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'No', value: e.no),
              DataGridCell<String>(columnName: 'ID', value: e.id),
              DataGridCell<String>(
                  columnName: 'Service Type', value: e.serviceType),
              DataGridCell<String>(columnName: 'Client', value: e.client),
              DataGridCell<String>(
                  columnName: 'Project Name', value: e.projectName),
              DataGridCell<String>(columnName: 'Address', value: e.address),
              DataGridCell<int>(columnName: 'Qty', value: e.qty),
              DataGridCell<String>(columnName: 'Server IP', value: e.serverIp),
              DataGridCell<String>(
                  columnName: 'Project Manager', value: e.projectManager),
              DataGridCell<String>(columnName: 'Status', value: e.status),
              DataGridCell<String>(
                  columnName: 'Start Date', value: dateValidate(e.startDate)),
              DataGridCell<String>(
                  columnName: 'Due Date', value: dateValidate(e.dueDate)),
              DataGridCell<String>(
                  columnName: 'Complete Date',
                  value: dateValidate(e.completeDate)),
              DataGridCell<String>(
                  columnName: 'Task Owner', value: e.taskOwner),
              DataGridCell<String>(
                  columnName: 'Chrono Status', value: e.chronoStatus),
              DataGridCell<String>(
                  columnName: 'Date Chronopost',
                  value: dateValidate(e.dateChronopost)),
              DataGridCell<String>(
                  columnName: 'Number Chronopost', value: e.numberChronopost),
              DataGridCell<String>(columnName: 'Remarks', value: e.remarks),
            ]))
        .toList();
  }

  @override
  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    TodoManager().getAll();
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
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value ??
        '';

    final int dataRowIndex = _toDoData.indexOf(dataGridRow);

    if (oldValue == newCellValue || newCellValue == null) {
      newCellValue = oldValue;
      return;
    }

    for (var element in columnData) {
      if (column.columnName == element) {
        rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
            DataGridCell(columnName: element, value: newCellValue);
      }
    }
    todo
        .insert(rows[dataRowIndex].getCells()[0].value, column.columnName,
            newCellValue)
        .then((value) {
      if (value == false) {
        MyToast.show("Error: gsheets error");
      }
    });
  }

  // toGsheets(r, c, v) async {
  //   bool success = await todo.insert(r, c, v);
  //   return success;
  // }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType = column.columnName == 'Qty';
    final bool isMultiLine = column.columnName == 'Address' ||
        column.columnName == 'Number Chronopost' ||
        column.columnName == 'Remarks' ||
        column.columnName == 'Server IP';
    final bool isSelectable = column.columnName == 'Service Type' ||
        column.columnName == 'Client' ||
        column.columnName == 'Project Manager' ||
        column.columnName == 'Status' ||
        column.columnName == 'Chrono Status' ||
        column.columnName == 'Task Owner';
    final bool isDate = column.columnName.contains('Date');

    //  deal with Date data
    if (isDate) {
      late DateTime selectedDate;
      void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
        selectedDate = args.value;
      }

      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: TextField(
          mouseCursor: MouseCursor.defer,
          readOnly: true,
          maxLines: null,
          autofocus: true,
          controller: editingController..text = displayText,
          textAlign: TextAlign.center,
          onTap: () {
            Get.defaultDialog(
              title: "Pick a date",
              content: SizedBox(
                height: 400,
                width: 400,
                child: SfDateRangePicker(
                    showNavigationArrow: true,
                    initialSelectedDate: DateTime.tryParse(displayText),
                    initialDisplayDate: DateTime.tryParse(displayText),
                    onSelectionChanged: _onSelectionChanged,
                    monthFormat: 'MMM',
                    headerStyle: const DateRangePickerHeaderStyle(
                        backgroundColor: Colors.amber,
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 25,
                          letterSpacing: 5,
                          color: Colors.white,
                        ))),
              ),
              confirm: TextButton(
                  onPressed: () {
                    editingController.text = dateValidate(selectedDate);
                    newCellValue = dateValidate(selectedDate);
                    submitCell();
                    Get.back();
                  },
                  child: const Text('CONFIRM')),
              cancel: TextButton(
                  onPressed: () => Get.back(), child: const Text('CANCEL')),
            );
          },
        ),
      );
    }

    // deal with selectable data
    if (isSelectable) {
      List<Map<String, String>> rowData = [];
      List res = [];

      for (var row in listTodoConfig) {
        res.add(row.toGsheets()[column.columnName]);
      }

      for (var row in res) {
        rowData.add({'value': row, 'display': row});
      }
      final _formKey = GlobalKey<FormState>();
      var value;
      return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
        child: TextField(
          mouseCursor: MouseCursor.defer,
          readOnly: true,
          maxLines: null,
          autofocus: true,
          controller: editingController..text = displayText,
          textAlign: TextAlign.center,
          onTap: () => Get.defaultDialog(
            radius: 2,
            title: column.columnName,
            content: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Form(
                key: _formKey,
                child: SearchField(
                  suggestions: res.cast(),
                  suggestionState: SuggestionState.enabled,
                  textInputAction: TextInputAction.done,
                  // controller: editingController,
                  hint: displayText,
                  maxSuggestionsInViewPort: 4,
                  itemHeight: 45,
                  validator: (x) {
                    if (!res.cast().contains(x)) {
                      return 'This is not a ${column.columnName}';
                    }
                    return null;
                  },
                  // suggestionAction: SuggestionAction.next,

                  onTap: (x) {
                    if (_formKey.currentState!.validate()) {
                      value = x;
                    }
                  },
                ),
              ),
            ),
            confirm: TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    editingController.text = value;
                    newCellValue = value;
                    submitCell();
                    Get.back();
                  }
                },
                child: const Text('CONFIRM')),
            cancel: TextButton(
                onPressed: () => Get.back(), child: const Text('CANCEL')),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        maxLines: null,
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
            // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),

            ),
        keyboardType: isNumericType
            ? TextInputType.number
            : isMultiLine
                ? TextInputType.multiline
                : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = displayText;
          }
        },
        onSubmitted: (String value) {
          // onCellSubmit(dataGridRow, rowColumnIndex, column);

          // In Mobile Platform.
          // Call [CellSubmit] callback to fire the canSubmitCell and
          // onCellSubmit to commit the new value in single place.
          // cellSubmit();
          submitCell();
        },
      ),
    );
  }
}
// 这里面的onEditingComplete 刷新 _TodoViewState里面的组件
