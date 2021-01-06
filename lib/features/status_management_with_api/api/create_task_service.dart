import 'package:click_up/common/constants.dart';
import 'package:http/http.dart' as http;

/// TODO implement error scenarios
class CreateTaskService {
  Future<bool> create(String request) async {
    try {
      final response =
          await http.post("https://api.clickup.com/api/v2/list/" + Constants.listId + "/task/",
              headers: {
                "Content-Type": "application/json",
                "Authorization": Constants.token
              },
              body: request);

      if (response.statusCode == 200) {
        return true;
      } else {
        print("ERROR - Create Task Service Response Code: " +
            response.statusCode.toString());
        return false;
      }
    } catch (e) {
      print("ERROR - Create Task Service");
      print(e);
      return false;
    }
  }
}
