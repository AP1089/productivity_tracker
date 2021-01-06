import 'package:click_up/core/framework/bloc_provider.dart';
import 'package:click_up/features/status_management_with_api/bloc/status_management_with_api_bloc.dart';
import 'package:click_up/features/status_management_with_api/ui/all_status_landing_ui.dart';
import 'package:flutter/material.dart';

class StatusManagementWithApiWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatusManagementWithApiBloc>(
        bloc: BlocProvider.of<StatusManagementWithApiBloc>(context) ??
            StatusManagementWithApiBloc(),
        child: MaterialApp(
          home: AllStatusLandingUI(),
        ));
  }
}
