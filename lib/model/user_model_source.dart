import 'package:auto_cv/model/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// UserModel's Source
class UserModelSource extends DataGridSource {
  UserModelSource({required List<UserModel> users}) {
    _users = users
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'name', value: e.name),
      DataGridCell<String>(columnName: 'headline', value: e.headline),
      DataGridCell<String>(
          columnName: 'location', value: e.location),
      DataGridCell<String>(columnName: 'email', value: e.email),
      DataGridCell<String>(columnName: 'github', value: e.github),
      DataGridCell<String>(columnName: 'number', value: e.number),
      DataGridCell<double>(columnName: 'experienceYear', value: e.experienceYear),
      DataGridCell<List<String>>(columnName: 'skillsFrontend', value: e.skillsFrontend),
      DataGridCell<List<String>>(columnName: 'skillsBackend', value: e.skillsBackend),
    ]))
        .toList();
  }

  List<DataGridRow>  _users = [];

  @override
  List<DataGridRow> get rows =>  _users;


  // String name;
  // String headline;
  // String location;
  // String email;
  // String github;
  // String number;
  // double experienceYear;
  // List<String> skillsFrontend;
  // List<String> skillsBackend;

  /// 각 셀에 해당하는 Row를 만든다. 어떤 위젯으로 표시할까
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Text(dataGridCell.value.toString()),
          );
        }).toList());
  }
}