class SpaceResponse {
  final String spaceName;
  final List<SingleStatusResponse> statusList;
  SpaceResponse({this.spaceName, this.statusList});

  factory SpaceResponse.fromJson(Map<String, dynamic> json) {
    return SpaceResponse(
        spaceName: json['name'],
        statusList: json['statuses']
            .map<SingleStatusResponse>(
                (json) => SingleStatusResponse.fromJson(json))
            .toList());
  }
}

class SingleStatusResponse {
  final String name;
  final String color;

  SingleStatusResponse({this.name, this.color});

  factory SingleStatusResponse.fromJson(Map<String, dynamic> json) {
    return SingleStatusResponse(name: json['status'], color: json['color']);
  }
}
