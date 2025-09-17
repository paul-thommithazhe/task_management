import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_management_app/data/models/task_models.dart';
import 'package:task_management_app/presentation/bloc/task_bloc.dart';
import 'package:task_management_app/presentation/bloc/task_event_bloc.dart';
import 'package:task_management_app/presentation/screens/task_list_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // register the adapter
  Hive.registerAdapter(TaskModelAdapter());

  // open the box
  await Hive.openBox<TaskModel>('tasks');
  // open the box
  final taskBox = await Hive.openBox<TaskModel>('tasks');

  runApp(MyApp(taskBox: taskBox));
}

class MyApp extends StatelessWidget {
  final Box<TaskModel> taskBox;

  const MyApp({super.key, required this.taskBox});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskBloc(taskBox)..add(LoadTasksEvent()),
      child: MaterialApp(
        title: 'Flutter Demo',

        theme: ThemeData(
          // app background color theme
          scaffoldBackgroundColor: const Color(0xFF181821),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF181821),
            foregroundColor: Colors.white, // appbar text/icons
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white), // default white
            bodyMedium: TextStyle(color: Colors.white70), // secondary text
            bodySmall: TextStyle(color: Colors.white70),
          ),
        ),

        home: TaskListHomeScreen(),
      ),
    );
  }
}
