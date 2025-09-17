import 'package:task_management_app/domain/entities/task.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class UpdateTaskStatusEvent extends TaskEvent {
  final String taskId;
  final bool isCompleted;

  UpdateTaskStatusEvent({required this.taskId, required this.isCompleted});
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  DeleteTaskEvent({required this.taskId});
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  UpdateTaskEvent(this.task);
}
