import 'dart:async';
import 'package:click_up/common/shared_strings.dart';
import 'package:click_up/core/framework/bloc_provider.dart';
import 'package:click_up/features/status_management_with_sqlite/api/space_response.dart';
import 'package:click_up/features/status_management_with_sqlite/api/space_service.dart';
import 'package:click_up/features/status_management_with_sqlite/database_helper.dart';
import 'package:click_up/features/status_management_with_sqlite/model/status_management_model.dart';
import 'package:click_up/features/status_management_with_sqlite/ui/status_management_with_sqlite_strings.dart';
import 'package:click_up/ui_kit/ui_utils.dart';

const _sharedStrings = SharedStrings();
const _strings = StatusManagementWithSQLiteStrings();

class StatusManagementWithSQLiteBloc extends Bloc {
  StatusManagementModel _model = StatusManagementModel();

  /// All Status Landing Screen Pipes
  final allStatusLandingStatusesRequestPipe =
      StreamController<List<SingleStatusModel>>();
  final allStatusLandingSpaceNameRequestPipe = StreamController<String>();
  final updateSelectedStatusPipe = StreamController<SingleStatusModel>();

  /// Status Detail Screen Pipes
  final statusDetailNavigationTitleRequestPipe =
      StreamController<String>.broadcast();
  final statusDetailTaskListRequestPipe =
      StreamController<List<SingleTaskModel>>.broadcast();

  /// Create Task Page Pipes
  final createTaskDetailsPipe = StreamController<Map>();
  final createTaskSuccessStatusPipe = StreamController<bool>.broadcast();

  StatusManagementWithSQLiteBloc() {
    updateSelectedStatusPipe.stream
        .listen((status) => _updateSelectedStatus(status));
    createTaskDetailsPipe.stream
        .listen((taskDetails) => _createTask(taskDetails));
  }

  Future<void> requestSpaceData() async {
    if (_model.allStatusList.isEmpty) {
      SpaceService _spaceService = SpaceService();
      SpaceResponse response = await _spaceService.fetchSpaceData();
      _model.spaceName = response.spaceName;
      response.statusList.forEach((status) {
        _model.allStatusList.add(SingleStatusModel(
            status.name.toUpperCase(), UIUtils.getColorFromHex(status.color)));
      });

      allStatusLandingStatusesRequestPipe.sink.add(_model.allStatusList);
      allStatusLandingSpaceNameRequestPipe.sink.add(_model.spaceName);
    }
  }

  Future<void> _updateSelectedStatus(SingleStatusModel status) async {
    _model.selectedStatus = status;
  }

  Future<void> requestStatusTaskListData() async {
    statusDetailNavigationTitleRequestPipe.sink.add(_model.selectedStatus.name);
    List<Map<String, dynamic>> _databaseTaskList = await DatabaseHelper.instance
        .getStatusTasks(_model.selectedStatus.name);
    if (_databaseTaskList != null) {
      List<SingleTaskModel> _taskList = [];
      _databaseTaskList.forEach((task) {
        _taskList.add(SingleTaskModel(
            task[_strings.taskName],
            _model.selectedStatus.color,
            (task[_strings.tags].isNotEmpty)
                ? task[_strings.tags].split(_sharedStrings.comma)
                : []));
      });
      _model.taskList = _taskList;
    }
    statusDetailTaskListRequestPipe.sink.add(_model.taskList);
  }

  Future<void> _createTask(Map task) async {
    String taskName = task[_sharedStrings.name];
    String taskTagsString = task[_sharedStrings.tags];

    if (taskName.isNotEmpty) {
      Map<String, dynamic> row = {
        DatabaseHelper.column1TaskName: taskName,
        DatabaseHelper.column2Status: _model.selectedStatus.name,
        DatabaseHelper.column3Tags: taskTagsString
      };

      int createdId = await DatabaseHelper.instance.addTask(row);
      if (createdId != null) {
        createTaskSuccessStatusPipe.sink.add(true);
      } else {
        createTaskSuccessStatusPipe.sink.add(false);
      }
    }
  }

  @override
  void dispose() {
    allStatusLandingStatusesRequestPipe.close();
    allStatusLandingSpaceNameRequestPipe.close();
    statusDetailNavigationTitleRequestPipe.close();
    statusDetailTaskListRequestPipe.close();
    updateSelectedStatusPipe.close();
    createTaskDetailsPipe.close();
    createTaskSuccessStatusPipe.close();
  }
}
