import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:task_management_app/presentation/bloc/task_bloc.dart';
import 'package:task_management_app/presentation/bloc/task_event_bloc.dart';
import 'package:task_management_app/presentation/bloc/task_states_bloc.dart';
import 'package:task_management_app/presentation/screens/task_add_screen.dart';

class TaskListHomeScreen extends StatefulWidget {
  const TaskListHomeScreen({super.key});

  @override
  State<TaskListHomeScreen> createState() => _TaskListHomeScreenState();
}

class _TaskListHomeScreenState extends State<TaskListHomeScreen> {
  String selectedStatus = "All"; // "All", "Pending", "Completed"
  final todayDate = DateFormat('MMM d').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            );
          } else if (state is TaskLoaded) {
            final tasks = state.tasks;

            // Filter tasks by status
            List filteredTasks;
            if (selectedStatus == "All") {
              filteredTasks = tasks;
            } else if (selectedStatus == "Pending") {
              filteredTasks = tasks
                  .where((task) => task.isCompleted == false)
                  .toList();
            } else {
              filteredTasks = tasks
                  .where((task) => task.isCompleted == true)
                  .toList();
            }

            // Tasks due today for the top container
            final today = DateTime.now();
            final tasksDueToday = tasks.where((task) {
              return task.dueDate.year == today.year &&
                  task.dueDate.month == today.month &&
                  task.dueDate.day == today.day;
            }).toList();
            return filteredTasks.isEmpty &&
                    (selectedStatus != "Completed" &&
                        selectedStatus != "Pending" &&
                        selectedStatus != "All")
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Lottie.asset("assets/nothing.json")),
                      Text("No Task , Please Add new Task"),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          "All Tasks",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Top summary container
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4EBADE), Color(0xFF2A7860)],
                            ),
                          ),
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tasksDueToday.isEmpty
                                    ? "No Tasks For Today 🎉"
                                    : "${tasksDueToday.length} Tasks to Complete Today!",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    filteredTasks.length < 2
                                        ? "Your productivity is good 🚀"
                                        : "Focus on your Tasks !! 😑",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      todayDate.toUpperCase(), // e.g. "Sep 17"
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 16, 246, 85),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Status filter row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: ["All", "Pending", "Completed"].map((
                            status,
                          ) {
                            final isSelected = selectedStatus == status;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedStatus = status;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF4EBADE)
                                      : const Color(0xFF2F3133),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 10),

                        // Task list
                        Expanded(
                          child: filteredTasks.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No tasks in this category",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: filteredTasks.length,
                                  itemBuilder: (context, index) {
                                    final task = filteredTasks[index];
                                    return Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            color: const Color(0xFF2F3133),
                                          ),
                                          padding: const EdgeInsets.all(25),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    task.title,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: task.isCompleted,
                                                    onChanged: (value) {
                                                      context
                                                          .read<TaskBloc>()
                                                          .add(
                                                            UpdateTaskStatusEvent(
                                                              taskId: task.id,
                                                              isCompleted:
                                                                  value ??
                                                                  false,
                                                            ),
                                                          );
                                                    },
                                                    activeColor: const Color(
                                                      0xFF4EBADE,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                task.description,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                'Due: ${DateFormat('MMM d, y').format(task.dueDate)}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: task.isCompleted
                                                          ? Color(0xFF6DF413)
                                                          : Colors.orange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),

                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Text(
                                                        'Status: ${task.isCompleted ? "Completed" : "Pending"}',
                                                        style: TextStyle(
                                                          color:
                                                              task.isCompleted
                                                              ? Colors.black
                                                              : Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              AddNewTaskScreen(
                                                                taskToEdit:
                                                                    task, // pass the task you want to edit
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.edit_note,
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () async {
                                                      // Show confirmation dialog
                                                      final bool?
                                                      confirmDelete = await showDialog<bool>(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              'Delete Task',
                                                            ),
                                                            content: const Text(
                                                              'Are you sure you want to delete this task?',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop(
                                                                      false,
                                                                    ), // Cancel
                                                                child:
                                                                    const Text(
                                                                      'Cancel',
                                                                    ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop(
                                                                      true,
                                                                    ), // Confirm
                                                                child: const Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );

                                                      // If user confirmed, delete the task
                                                      if (confirmDelete ==
                                                          true) {
                                                        context
                                                            .read<TaskBloc>()
                                                            .add(
                                                              DeleteTaskEvent(
                                                                taskId: task.id,
                                                              ),
                                                            );

                                                        // Optional: show a SnackBar
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Task deleted successfully',
                                                            ),
                                                            backgroundColor:
                                                                Colors.red,
                                                            duration: Duration(
                                                              seconds: 2,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
          } else if (state is TaskError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text("OMG!!!!"));
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 8,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2F3133),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      selectedStatus = "All";
                    });
                  },
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const AddNewTaskScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF4EBADE),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  label: const Text("Add New Task"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
