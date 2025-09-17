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
  }

  void _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) {
    final tasks = taskBox.values.toList(); // List<TaskModel>
    emit(TaskLoaded(tasks));
  }

  void _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final model = TaskModel.fromEntity(event.task);
      await taskBox.add(model);

      final tasks = taskBox.values.toList(); // List<TaskModel>
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError("Failed to add task: $e"));
    }
  }
}
