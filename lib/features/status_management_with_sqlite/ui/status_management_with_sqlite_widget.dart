import 'package:click_up/core/framework/bloc_provider.dart';
import 'package:click_up/features/status_management_with_sqlite/bloc/status_management_with_sqlite_bloc.dart';
import 'package:click_up/features/status_management_with_sqlite/ui/all_status_landing_ui.dart';
import 'package:flutter/material.dart';

class StatusManagementWithSQLiteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatusManagementWithSQLiteBloc>(
        bloc: BlocProvider.of<StatusManagementWithSQLiteBloc>(context) ??
            StatusManagementWithSQLiteBloc(),
        child: MaterialApp(
          home: AllStatusLandingUI(),
        ));
  }
}
