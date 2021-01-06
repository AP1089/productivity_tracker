import 'dart:convert';
import 'package:click_up/common/constants.dart';
import 'package:click_up/features/status_management_with_api/api/tasks_response.dart';
import 'package:http/http.dart' as http;

/// TODO implement error scenarios
class TasksService {
  Future<TaskResponse> fetchTasks(String status) async {
    try {
      var response = await http.get(
        "https://api.clickup.com/api/v2/list/" + Constants.listId + "/task/?archived=false&statuses%5B%5D=$status",
        headers: {
          "Accept": "application/json",
          "Authorization": Constants.token
        },
      );
      if (response.statusCode == 200) {
        TaskResponse _taskResponse =
            TaskResponse.fromJson(json.decode(response.body));
        return _taskResponse;
      } else {
        print("ERROR - Fetch Tasks Service Error Code: " +
            response.statusCode.toString());
        return null;
      }
    } catch (e) {
      print("ERROR - Fetch Tasks Service");
      print(e);
      return null;
    }
  }
}
