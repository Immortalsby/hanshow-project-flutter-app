import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hanshow_project_google_sheets/views/left_sidebar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../utils/constant.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import '../widgets/my_toast.dart';
import '../utils/shared_preferences_util.dart';
import '../models/action_model.dart';
import '../models/todo_model.dart';
import '../models/add_history.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';

class ActionPlanView extends StatefulWidget {
  const ActionPlanView({Key? key}) : super(key: key);

  @override
  _ActionPlanViewState createState() => _ActionPlanViewState();
}

final actionPlan = ActionPlanManager();
List columnData = [];
List<TodoConfig> listTodoConfig = [];
List configData = [];
final todoConfig = TodoConfigManager();

class _ActionPlanViewState extends State<ActionPlanView> {
  StreamController<List> streamController = StreamController();
  late ActionPlanDataSource actionPlanDataSource;

  Future getData() async {
    var data = await actionPlan.getAll();

    streamController.add(data!);
  }

  Future getColumnData() async {
    columnData = await actionPlan.getColumnName()!;
  }
  Future getConfigData() async {
    var data = await todoConfig.getAll();

    listTodoConfig = data!;
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

  String? valueType;
  String? valueContent;

  late Map<String, double> columnWidths = {
    'Client': double.nan,
    'Action': double.nan,
    'Due Date': double.nan,
    'Start Date': double.nan,
    'Status': double.nan,
    'Task Owner': double.nan,
    'Remarks': double.nan,
  };

  @override
  Widget build(BuildContext context) {
    if (SharedPreferenceUtil.getBool('isLoggedIn') == false) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("ActionPlan Plan"),
            elevation: 0,
          ),
          body: MyToast.show('Ops, You are not logged in yet!'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("ActionPlan Plan"),
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
                  actionPlanDataSource = ActionPlanDataSource(
                    actionPlanData: snapshot.data!.cast<ActionPlan>(),
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
                      allowPullToRefresh: true,
                      source: actionPlanDataSource,
                      columnWidthMode: ColumnWidthMode.auto,
                      headerRowHeight:
                          !kIsWeb && Platform.isAndroid ? 70 : double.nan,
                      rowHeight:
                          !kIsWeb && Platform.isAndroid ? 70 : double.nan,
                      onQueryRowHeight: (details) {
                        return !kIsWeb && Platform.isAndroid
                            ? 50
                            : details.getIntrinsicRowHeight(details.rowIndex);
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
                            width: columnWidths['Client']!,
                            minimumWidth: 100.0,
                            columnName: 'Client',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Client'))),
                        GridColumn(
                            width: columnWidths['Action']!,
                            minimumWidth: 120.0,
                            columnName: 'Action',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Action'))),
                        GridColumn(
                            width: columnWidths['Start Date']!,
                            minimumWidth: 100.0,
                            columnName: 'Start Date',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Start Date'))),
                        GridColumn(
                            width: columnWidths['Due Date']!,
                            minimumWidth: 100.0,
                            columnName: 'Due Date',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Due Date'))),
                        GridColumn(
                            width: columnWidths['Status']!,
                            minimumWidth: 100.0,
                            columnName: 'Status',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Status'))),
                        GridColumn(
                            width: columnWidths['Task Owner']!,
                            minimumWidth: 100.0,
                            columnName: 'Task Owner',
                            label: Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: const Text('Task Owner'))),
                        GridColumn(
                            width: columnWidths['Remarks']!,
                            minimumWidth: 100.0,
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
      drawer: const LeftSideBar(),
    );
  }
}

class ActionPlanDataSource extends DataGridSource {
  /// Creates the todo data source
  ActionPlanDataSource({required List<ActionPlan> actionPlanData}) {
    _actionPlanData = actionPlanData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Client', value: e.client),
              DataGridCell<String>(columnName: 'Action', value: e.action),
              DataGridCell<String>(
                  columnName: 'Start Date', value: dateValidate(e.startDate)),
              DataGridCell<String>(
                  columnName: 'Due Date', value: dateValidate(e.dueDate)),
              DataGridCell<String>(columnName: 'Status', value: e.status),
              DataGridCell<String>(columnName: 'Task Owner', value: e.taskOwner),
              DataGridCell<String>(columnName: 'Remarks', value: e.remarks),
            ]))
        .toList();
  }

  @override
  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    ActionPlanManager().getAll();
  }

  List<DataGridRow> _actionPlanData = [];

  @override
  List<DataGridRow> get rows => _actionPlanData;

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

    final int dataRowIndex = _actionPlanData.indexOf(dataGridRow);

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
    // Insert to Gsheets!!!!!!!!!!!!!!   !important
    actionPlan
        .insert(dataRowIndex, rowColumnIndex.columnIndex,
            newCellValue)
        .then((value) {
      if (value == false) {
        MyToast.show("Error: gsheets error");
      } else {
        AddHistory().add(
            SharedPreferenceUtil.getString('name'),
            oldValue,
            newCellValue,
            'ActionPlan',
            dataRowIndex,
            rowColumnIndex.columnIndex);
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

    final bool isMultiLine =
        column.columnName == 'Action' || column.columnName == 'Remarks';
    final bool isSelectable = column.columnName == 'Client' ||
        column.columnName == 'Status' ||
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
      String? value = "No Data";
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
                  // suggestionActionPlan: SuggestionActionPlan.next,

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
                    editingController.text = value!;
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
      alignment: Alignment.centerLeft,
      child: TextField(
        maxLines: null,
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
            // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),

            ),
        keyboardType: isMultiLine
                ? TextInputType.multiline
                : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
              newCellValue = value;
          } else {
            newCellValue = ' ';
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
// 这里面的onEditingComplete 刷新 _ActionPlanViewState里面的组件
