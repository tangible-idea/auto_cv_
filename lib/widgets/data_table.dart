
import 'package:auto_cv/model/user_model_source.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/user_model.dart';
import '../riverpod/user_profilelist_provider.dart';

/// refer to [UserModel]
class CVTable extends ConsumerWidget {
  CVTable({super.key}) {
    _userModelSource= UserModelSource(users: _users);
  }

  late UserModelSource _userModelSource;
  final List<UserModel> _users = <UserModel>[];

  // String name;
  // String headline;
  // String location;
  // String email;
  // String github;
  // String number;
  // double experienceYear;
  // List<String> skillsFrontend;
  // List<String> skillsBackend;
  /// header 부분..
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider= ref.watch(userProfileListProvider);

    if (userProvider.isEmpty) {
      return const SizedBox.shrink();
    }

    const marginSys16= EdgeInsets.symmetric(horizontal: 16.0);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 500),
      child: SfDataGrid(
        gridLinesVisibility: GridLinesVisibility.both,
        columnWidthMode: ColumnWidthMode.auto,
        allowFiltering: true,
        source: UserModelSource(users: userProvider),
        columns: [
          GridColumn(
              columnName: 'name',
              label: Container(
                  padding: marginSys16,
                  alignment: Alignment.center,
                  child: const Text(
                    'Name',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'headline',
              label: Container(
                  padding: marginSys16,
                  alignment: Alignment.center,
                  child: const Text(
                    'Headline',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'location',
              label: Container(
                  padding: marginSys16,
                  alignment: Alignment.center,
                  child: const Text(
                    'Location',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'email',
              label: Container(
                  padding: marginSys16,
                  alignment: Alignment.center,
                  child: const Text(
                    'Email',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'github',
              label: Container(
                  padding: marginSys16,
                  alignment: Alignment.center,
                  child: const Text(
                    'Github',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'number',
              label: Container(
                  padding: marginSys16,
                  alignment: Alignment.center,
                  child: const Text(
                    'Number',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'experienceYear',
              label: Container(
                  padding: marginSys16,
                  alignment: Alignment.center,
                  child: const Text(
                    'experienceYear',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'skillsFrontend',
              label: Container(
                  padding: marginSys16,
                  alignment: Alignment.center,
                  child: const Text(
                    'skillsFrontend',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridColumn(
              columnName: 'skillsBackend',
              label: Container(
                  padding: marginSys16,
                  alignment: Alignment.center,
                  child: const Text(
                    'skillsBackend',
                    overflow: TextOverflow.ellipsis,
                  ))),
      ],)
    );
  }
}

