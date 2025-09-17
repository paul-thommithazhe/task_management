import 'package:task_management_app/data/datasources/task_local_datasouce.dart';
import 'package:task_management_app/data/models/task_models.dart';
import 'package:task_management_app/domain/repository/respository.dart';

import '../../domain/entities/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    await localDataSource.addTask(model);
  }

  @override
  Future<List<Task>> getTasks() async {
    final models = await localDataSource.getTasks();
    return models.map((e) => e.toEntity()).toList();
  }
}
