import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String taskTitle;
  @HiveField(1)
  String taskDescription;
  @HiveField(2)
  String taskDate;
  @HiveField(3)
  String taskStartTime;
  @HiveField(4)
  String taskEndTime;
  @HiveField(5)
  String taskStatusText;
  @HiveField(6)
  int color;

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
      'color': color,
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
      color: map['color'],
    );
  }
}
