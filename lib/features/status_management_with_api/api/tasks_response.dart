class TaskResponse {
  final List<SingleTaskResponse> statusList;
  TaskResponse({this.statusList});

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
        statusList: json['tasks']
            .map<SingleTaskResponse>(
                (json) => SingleTaskResponse.fromJson(json))
            .toList());
  }
}

class SingleTaskResponse {
  final String name;
  final String statusColor;
  final List<dynamic> tags;

  SingleTaskResponse({this.name, this.statusColor, this.tags});

  factory SingleTaskResponse.fromJson(Map<String, dynamic> json) {
    return SingleTaskResponse(
        name: json['name'],
        statusColor: json['status']['color'],
        tags: json['tags']);
  }
}
