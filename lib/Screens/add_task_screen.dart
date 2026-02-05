import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/Models/task_model.dart';
import 'package:todo_app/custom_widgets/app_button.dart';
import 'package:todo_app/custom_widgets/app_text_form_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  var formKey = GlobalKey<FormState>();
  int selectedColorIndex = 0;
  List<Color> taskColors = [Colors.red, Colors.blue, Colors.green];

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();

    DateTime now = DateTime.now();
    dateController = TextEditingController(
      text: "${now.day}/${now.month}/${now.year}",
    );

    startTimeController = TextEditingController();
    endTimeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        startTimeController.text = TimeOfDay.now().format(context);
        endTimeController.text = _getOppositeTime(context);
      });
    });
  }

  String _getOppositeTime(BuildContext context) {
    TimeOfDay now = TimeOfDay.now();
    final localizations = MaterialLocalizations.of(context);

    String formattedTime = now.format(context);
    if (now.period == DayPeriod.am) {
      return formattedTime.replaceAll(
        localizations.anteMeridiemAbbreviation,
        localizations.postMeridiemAbbreviation,
      );
    } else {
      return formattedTime.replaceAll(
        localizations.postMeridiemAbbreviation,
        localizations.anteMeridiemAbbreviation,
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.deepPurple),
          titleTextStyle: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          title: const Text("Add Task"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Title",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                AppTextFormField(
                  controller: titleController,
                  hintText: "Enter Task Title",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Task Title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  controller: descriptionController,
                  hintText: "Enter Task description",
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Task Description';
                    }
                    return null;
                  },
                ),
                const Text(
                  "Date",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  controller: dateController,
                  suffixIcon: const Icon(Icons.date_range),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(3000),
                      initialDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            useMaterial3: false,
                            colorScheme: const ColorScheme.light(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              onSurface: Colors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Start Time",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextFormField(
                            controller: startTimeController,
                            suffixIcon: const Icon(Icons.alarm),
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      useMaterial3: false,
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.blue,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  startTimeController.text = pickedTime.format(
                                    context,
                                  );
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "End Time",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextFormField(
                            controller: endTimeController,
                            suffixIcon: const Icon(Icons.alarm),
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      useMaterial3: false,
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.blue,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  endTimeController.text = pickedTime.format(
                                    context,
                                  );
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: List.generate(
                    3,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColorIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: taskColors[index],
                          child: selectedColorIndex == index
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  title: "confirm",
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      Box<TaskModel> tasksBox = Hive.box<TaskModel>('tasks');
                      tasksBox.add(
                        TaskModel(
                          taskTitle: titleController.text,
                          taskDescription: descriptionController.text,
                          taskDate: dateController.text,
                          taskStartTime: startTimeController.text,
                          taskEndTime: endTimeController.text,
                          taskStatusText: "todo",
                          color: taskColors[selectedColorIndex].value,
                        ),
                      );
                      Navigator.pop(context, dateController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
