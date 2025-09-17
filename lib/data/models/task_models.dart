import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';

part 'task_models.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime dueDate;

  @HiveField(3)
  bool isCompleted;

  TaskModel({
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  // Convert Entity -> Model
  factory TaskModel.fromEntity(Task task) => TaskModel(
    title: task.title,
    description: task.description,
    dueDate: task.dueDate,
    isCompleted: task.isCompleted,
  );

  // Convert Model -> Entity
  Task toEntity() => Task(
    title: title,
    description: description,
    dueDate: dueDate,
    isCompleted: isCompleted,
  );

  // Add copyWith for easy updates
  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TaskModel(
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
