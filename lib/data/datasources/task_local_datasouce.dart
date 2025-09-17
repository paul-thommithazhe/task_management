import 'package:hive/hive.dart';
import 'package:task_management_app/data/models/task_models.dart';

class TaskLocalDataSource {
  final Box<TaskModel> box;

  TaskLocalDataSource(this.box);

  Future<void> addTask(TaskModel task) async {
    await box.add(task);
  }

  Future<List<TaskModel>> getTasks() async {
    return box.values.toList();
  }
}
