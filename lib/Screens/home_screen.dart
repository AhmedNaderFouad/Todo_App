import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/Models/task_model.dart' as model;
import 'package:todo_app/Screens/add_task_screen.dart';
import 'package:todo_app/Screens/profile_screen.dart';
import 'package:todo_app/Services/storage_service.dart';
import 'package:todo_app/custom_widgets/app_button.dart';
import 'package:todo_app/custom_widgets/task_card.dart';
import 'package:todo_app/custom_widgets/calendar_item.dart';
import 'package:todo_app/main.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final String? imagePath;

  const HomeScreen({super.key, required this.name, this.imagePath});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String currentName;
  String? currentImagePath;
  DateTime selectedDate = DateTime.now();
  final List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];
  final List<String> weekDays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  @override
  void initState() {
    super.initState();
    currentName = widget.name;
    currentImagePath = widget.imagePath;
  }

  String getMonthName(int month) => months[month - 1];
  String getDayName(int weekday) => weekDays[weekday - 1];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    Set<DateTime> uniqueDates = {today};
    for (var task in model.tasks) {
      List<String> parts = task.taskDate.split('/');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        uniqueDates.add(DateTime(year, month, day));
      }
    }

    List<DateTime> sortedDates = uniqueDates.toList()..sort();

    final filteredTasks = model.tasks.where((task) {
      List<String> parts = task.taskDate.split('/');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return day == selectedDate.day &&
            month == selectedDate.month &&
            year == selectedDate.year;
      }
      return false;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, $currentName",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(
                          "Have a Nice Day",
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            name: currentName,
                            imagePath: currentImagePath,
                          ),
                        ),
                      );
                      if (result != null && result is Map) {
                        setState(() {
                          currentName = result['name'];
                          currentImagePath = result['imagePath'];
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: currentImagePath != null
                          ? FileImage(File(currentImagePath!))
                          : null,
                      child: currentImagePath == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getMonthName(now.month)} ${now.day}, ${now.year}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Today",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 150,
                    child: AppButton(
                      title: "+ Add Task",
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddTaskScreen(),
                          ),
                        );

                        if (result != null && result is String) {
                          List<String> parts = result.split('/');
                          if (parts.length == 3) {
                            setState(() {
                              selectedDate = DateTime(
                                int.parse(parts[2]),
                                int.parse(parts[1]),
                                int.parse(parts[0]),
                              );
                            });
                          }
                        }

                        await StorageService.saveTasks(model.tasks);
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: sortedDates.map((date) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: CalendarItem(
                        month: getMonthName(date.month),
                        day: date.day.toString(),
                        weekDay: getDayName(date.weekday),
                        isSelected:
                            selectedDate.day == date.day &&
                            selectedDate.month == date.month &&
                            selectedDate.year == date.year,
                        onTap: () => setState(() => selectedDate = date),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
              if (filteredTasks.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Lottie.asset("assets/images/no_data.json", height: 250),
                      const Text(
                        "No tasks for this day!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...filteredTasks
                    .asMap()
                    .entries
                    .map((entry) => dismissibleTask(entry.key, entry.value))
                    .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget dismissibleTask(int index, model.TaskModel task) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async {
        setState(() {
          model.tasks.remove(task);
        });
        await StorageService.saveTasks(model.tasks);
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Row(
          children: [
            Icon(Icons.check, color: Colors.white, size: 30),
            SizedBox(width: 10),
            Text(
              "Complete",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 30),
            SizedBox(width: 10),
            Text(
              "Delete Task",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      child: TaskCard(
        title: task.taskTitle,
        time: "${task.taskStartTime} - ${task.taskEndTime}",
        description: task.taskDescription,
        color: task.color,
        isCompleted: task.taskStatusText == "completed",
      ),
    );
  }
}