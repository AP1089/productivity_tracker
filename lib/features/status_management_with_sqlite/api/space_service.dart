import 'dart:convert';
import 'package:click_up/common/constants.dart';
import 'package:click_up/features/status_management_with_sqlite/api/space_response.dart';
import 'package:http/http.dart' as http;

/// TODO implement error scenarios
class SpaceService {
  Future<SpaceResponse> fetchSpaceData() async {
    try {
      var response = await http.get(
        "https://api.clickup.com/api/v2/space/" + Constants.spaceId,
        headers: {
          "Accept": "application/json",
          "Authorization": Constants.token
        },
      );
      if (response.statusCode == 200) {
        SpaceResponse _spaceResponse =
            SpaceResponse.fromJson(json.decode(response.body));
        return _spaceResponse;
      } else {
        print("ERROR - Fetch Space Service Error Code: " +
            response.statusCode.toString());
        return null;
      }
    } catch (e) {
      print("ERROR - Fetch Space Service");
      print(e);
      return null;
    }
  }
}
