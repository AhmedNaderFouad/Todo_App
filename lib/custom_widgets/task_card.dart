import 'package:flutter/material.dart';
import 'package:todo_app/Models/task_model.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String description;
  final Color color;
  final bool isCompleted;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.description,
    required this.color,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green : color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white, size: 16),
                    SizedBox(width: 5),
                    Text(
                      time,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(description, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: Colors.white24,
            margin: EdgeInsets.symmetric(horizontal: 15),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              isCompleted ? "COMPLETED" : "TODO",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
