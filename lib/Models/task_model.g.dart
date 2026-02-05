part of 'task_model.dart';

@HiveType(typeId: 0)
class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      taskTitle: fields[0] as String,
      taskDescription: fields[1] as String,
      taskDate: fields[2] as String,
      taskStartTime: fields[3] as String,
      taskEndTime: fields[4] as String,
      taskStatusText: fields[5] as String,
      color: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.taskTitle)
      ..writeByte(1)
      ..write(obj.taskDescription)
      ..writeByte(2)
      ..write(obj.taskDate)
      ..writeByte(3)
      ..write(obj.taskStartTime)
      ..writeByte(4)
      ..write(obj.taskEndTime)
      ..writeByte(5)
      ..write(obj.taskStatusText)
      ..writeByte(6)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
