import 'package:hive/hive.dart';
import 'package:todo_app/Models/task_model.dart';

class TaskService {
  late Box<TaskModel> _taskBox;

  Future<void> init() async {
    _taskBox = await Hive.openBox<TaskModel>('tasks');
  }

  List<TaskModel> getTasks() {
    return _taskBox.values.toList();
  }

  Future<void> addTask(TaskModel task) async {
    await _taskBox.add(task);
  }

  Future<void> updateTask(int index, TaskModel task) async {
    await _taskBox.putAt(index, task);
  }

  Future<void> deleteTask(int index) async {
    await _taskBox.deleteAt(index);
  }
}
