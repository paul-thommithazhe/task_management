import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_management_app/data/models/task_models.dart';
import 'package:task_management_app/presentation/bloc/task_event_bloc.dart';
import 'package:task_management_app/presentation/bloc/task_states_bloc.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Box<TaskModel> taskBox;

  TaskBloc(this.taskBox) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdate);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) {
    print('working');

    final tasks = taskBox.values.map((model) => model.toEntity()).toList();
    emit(TaskLoaded(tasks));
  }

  void _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final model = TaskModel.fromEntity(event.task);
      await taskBox.add(model);

      final tasks = taskBox.values.map((m) => m.toEntity()).toList();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError("Failed to add task: $e"));
    }
  }

  void _onUpdate(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      // Find the task in Hive by ID
      final taskKey = taskBox.keys.firstWhere((key) {
        final task = taskBox.get(key);
        return task != null && task.id == event.task.id;
      });

      await taskBox.put(taskKey, TaskModel.fromEntity(event.task));

      final tasks = taskBox.values.map((m) => m.toEntity()).toList();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError("Failed to update task: $e"));
    }
  }

  void _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final taskKey = taskBox.keys.firstWhere((key) {
        final task = taskBox.get(key);
        return task != null && task.id == event.taskId;
      });

      await taskBox.delete(taskKey);

      final tasks = taskBox.values.map((m) => m.toEntity()).toList();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError("Failed to delete task: $e"));
    }
  }

  void _onUpdateTaskStatus(
    UpdateTaskStatusEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    try {
      print('working');
      // Find the task in Hive by ID
      final taskKey = taskBox.keys.firstWhere((key) {
        final task = taskBox.get(key);
        return task != null && task.id == event.taskId;
      });

      final taskModel = taskBox.get(taskKey);

      if (taskModel != null) {
        final updatedTask = taskModel.copyWith(isCompleted: event.isCompleted);
        await taskBox.put(taskKey, updatedTask);

        // Emit the updated list
        final tasks = taskBox.values.map((m) => m.toEntity()).toList();
        emit(TaskLoaded(tasks));
      }
    } catch (e) {
      emit(TaskError("Failed to update task status: $e"));
    }
  }
}
