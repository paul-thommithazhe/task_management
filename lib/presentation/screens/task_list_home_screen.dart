import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/presentation/bloc/task_bloc.dart';
import 'package:task_management_app/presentation/bloc/task_states_bloc.dart';
import 'package:task_management_app/presentation/screens/task_add_screen.dart';

class TaskListHomeScreen extends StatefulWidget {
  const TaskListHomeScreen({super.key});

  @override
  State<TaskListHomeScreen> createState() => _TaskListHomeScreenState();
}

class _TaskListHomeScreenState extends State<TaskListHomeScreen> {
  String selectedStatus = "All"; // "All", "Pending", "Completed"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "All Tasks",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          "${tasksDueToday.length} TASKS TO COMPLETE TODAY !",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Your productivity is good",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Status filter row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: ["All", "Pending", "Completed"].map((status) {
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
                              color: isSelected ? Colors.white : Colors.white70,
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
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xFF2F3133),
                                    ),
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              );
            } else if (state is TaskError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
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
                  onPressed: () {},
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
