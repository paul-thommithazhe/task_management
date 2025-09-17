import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class ToggleTaskCompletion extends TaskEvent {
  final int taskKey; // Hive key
  ToggleTaskCompletion(this.taskKey);
}
