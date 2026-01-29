import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Models/task_model.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _nameKey = 'user_name';
  static const String _imageKey = 'user_image';

  // Tasks Persistence
  static Future<void> saveTasks(List<TaskModel> taskList) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      taskList.map((task) => task.toMap()).toList(),
    );
    await prefs.setString(_tasksKey, encodedData);
  }

  static Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_tasksKey);
    if (tasksString != null) {
      final List<dynamic> decodedData = jsonDecode(tasksString);
      return decodedData.map((taskMap) => TaskModel.fromMap(taskMap)).toList();
    }
    return [];
  }

  // User Persistence
  static Future<void> saveUser(String name, String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    if (imagePath != null) {
      await prefs.setString(_imageKey, imagePath);
    } else {
      await prefs.remove(_imageKey);
    }
  }

  static Future<Map<String, String?>> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey),
      'imagePath': prefs.getString(_imageKey),
    };
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_nameKey);
  }
}
