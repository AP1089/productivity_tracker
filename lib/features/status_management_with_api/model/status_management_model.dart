import 'package:flutter/material.dart';

class StatusManagementModel {
  String spaceName;
  List<SingleStatusModel> allStatusList = [];
  String selectedStatus;
  List<SingleTaskModel> taskList = [];
}

class SingleStatusModel {
  String name;
  Color color;

  SingleStatusModel(this.name, this.color);
}

class SingleTaskModel {
  String name;
  Color statusColor;
  List<String> tags;
  SingleTaskModel(this.name, this.statusColor, this.tags);
}
