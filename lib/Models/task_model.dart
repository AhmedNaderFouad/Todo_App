import 'package:flutter/material.dart';

class TaskModel {
  String taskTitle;
  String taskDescription;
  String taskDate;
  String taskStartTime;
  String taskEndTime;
  String taskStatusText;
  Color color;

  TaskModel({
    required this.taskTitle,
    required this.taskDescription,
    required this.taskDate,
    required this.taskStartTime,
    required this.taskEndTime,
    required this.taskStatusText,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'taskDate': taskDate,
      'taskStartTime': taskStartTime,
      'taskEndTime': taskEndTime,
      'taskStatusText': taskStatusText,
      'color': color.value,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskTitle: map['taskTitle'],
      taskDescription: map['taskDescription'],
      taskDate: map['taskDate'],
      taskStartTime: map['taskStartTime'],
      taskEndTime: map['taskEndTime'],
      taskStatusText: map['taskStatusText'],
      color: Color(map['color']),
    );
  }
}

List<TaskModel> tasks = [];
