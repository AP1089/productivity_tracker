import 'dart:convert';

class CreateTaskRequest {
  final String name;
  final List<String> tags;
  final status;
  CreateTaskRequest({this.name, this.tags, this.status});

  String toJson() {
    Map<String, dynamic> data = {"name": name, "tags": tags, "status": status};
    return json.encode(data);
  }
}
