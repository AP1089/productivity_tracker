import 'dart:async';
import 'package:click_up/common/shared_strings.dart';
import 'package:click_up/core/framework/bloc_provider.dart';
import 'package:click_up/features/status_management_with_api/api/create_task_request.dart';
import 'package:click_up/features/status_management_with_api/api/create_task_service.dart';
import 'package:click_up/features/status_management_with_api/api/space_response.dart';
import 'package:click_up/features/status_management_with_api/api/space_service.dart';
import 'package:click_up/features/status_management_with_api/api/tasks_response.dart';
import 'package:click_up/features/status_management_with_api/api/tasks_service.dart';
import 'package:click_up/features/status_management_with_api/model/status_management_model.dart';
import 'package:click_up/ui_kit/ui_utils.dart';

const _sharedStrings = SharedStrings();

class StatusManagementWithApiBloc extends Bloc {
  StatusManagementModel _model = StatusManagementModel();

  /// All Status Landing Screen Pipes
  final allStatusLandingStatusesRequestPipe =
      StreamController<List<SingleStatusModel>>();
  final allStatusLandingSpaceNameRequestPipe = StreamController<String>();
  final updateSelectedStatusPipe = StreamController<String>();

  /// Status Detail Screen Pipes
  final statusDetailNavigationTitleRequestPipe =
      StreamController<String>.broadcast();
  final statusDetailTaskListRequestPipe =
      StreamController<List<SingleTaskModel>>.broadcast();

  /// Create Task Page Pipes
  final createTaskDetailsPipe = StreamController<Map>();
  final createTaskSuccessStatusPipe = StreamController<bool>.broadcast();

  StatusManagementWithApiBloc() {
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

  Future<void> requestStatusTaskListData() async {
    statusDetailNavigationTitleRequestPipe.sink.add(_model.selectedStatus);
    TasksService _taskService = TasksService();
    TaskResponse response =
        await _taskService.fetchTasks(_model.selectedStatus);
    List<SingleTaskModel> _taskList = [];
    response.statusList.forEach((task) {
      List<String> _tags = [];
      task.tags.forEach((tag) {
        _tags.add(tag[_sharedStrings.name]);
      });
      _taskList.add(SingleTaskModel(
          task.name, UIUtils.getColorFromHex(task.statusColor), _tags));
    });
    _model.taskList = _taskList;
    statusDetailTaskListRequestPipe.sink.add(_model.taskList);
  }

  Future<void> _updateSelectedStatus(String status) async {
    _model.selectedStatus = status;
  }

  Future<void> _createTask(Map task) async {
    String taskName = task[_sharedStrings.name];
    String taskTagsString = task[_sharedStrings.tags];

    if (taskName.isNotEmpty) {
      List<String> tags = [];
      if (taskTagsString.isNotEmpty) {
        tags = taskTagsString.split(_sharedStrings.comma);
      }

      CreateTaskRequest request = CreateTaskRequest(
          name: taskName, tags: tags, status: _model.selectedStatus);
      CreateTaskService _createTaskService = CreateTaskService();
      bool success = await _createTaskService.create(request.toJson());
      createTaskSuccessStatusPipe.sink.add(success);
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
