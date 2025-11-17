import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';
import '../utils/theme.dart';
import '../widgets/add_assignment_dialog.dart';
import '../widgets/add_exam_dialog.dart';
import '../widgets/add_todo_dialog.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    // FIX: Rebuild UI when switching tabs (so FAB updates)
    _tabController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).loadAllData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Assignments'),
            Tab(text: 'Exams'),
            Tab(text: 'To-Dos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _AssignmentsTab(),
          _ExamsTab(),
          _TodosTab(),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget? _buildFAB() {
    final index = _tabController.index;

    // FIX: Now this updates when switching tabs
    if (index == 0) {
      return FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const AddAssignmentDialog(),
        ),
        child: const Icon(Icons.add),
      );
    } else if (index == 1) {
      return FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const AddExamDialog(),
        ),
        child: const Icon(Icons.add),
      );
    } else {
      return FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const AddTodoDialog(),
        ),
        child: const Icon(Icons.add),
      );
    }
  }
}

// ----------------------------------------------------
// ASSIGNMENTS TAB
// ----------------------------------------------------

class _AssignmentsTab extends StatelessWidget {
  const _AssignmentsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        final assignments = dataProvider.assignments
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

        if (assignments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined,
                    size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No assignments yet',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final assignment = assignments[index];
            final isOverdue = !assignment.isCompleted &&
                assignment.dueDate.isBefore(DateTime.now());

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: isOverdue ? Colors.red.shade50 : null,
              child: ListTile(
                leading: Checkbox(
                  value: assignment.isCompleted,
                  onChanged: (value) {
                    dataProvider.updateAssignment(
                      assignment.copyWith(isCompleted: value ?? false),
                    );
                  },
                ),
                title: Text(
                  assignment.name,
                  style: TextStyle(
                    decoration: assignment.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(assignment.subject),
                    Text(
                      DateFormat('MMM d, y • h:mm a')
                          .format(assignment.dueDate),
                      style: TextStyle(
                        color: isOverdue
                            ? AppTheme.errorColor
                            : AppTheme.textSecondary,
                        fontWeight:
                            isOverdue ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    if (assignment.description != null)
                      Text(assignment.description!),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    dataProvider.deleteAssignment(assignment.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ----------------------------------------------------
// EXAMS TAB
// ----------------------------------------------------

class _ExamsTab extends StatelessWidget {
  const _ExamsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        final exams = dataProvider.exams
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

        if (exams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_outlined,
                    size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No exams scheduled',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: exams.length,
          itemBuilder: (context, index) {
            final exam = exams[index];
            final isUpcoming = exam.dateTime.isAfter(DateTime.now());
            final daysUntil =
                exam.dateTime.difference(DateTime.now()).inDays;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child:
                      const Icon(Icons.event, color: AppTheme.primaryColor),
                ),
                title: Text(
                  exam.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMM d, y • h:mm a')
                          .format(exam.dateTime),
                      style: TextStyle(
                        color: isUpcoming
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                        fontWeight:
                            isUpcoming ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    if (isUpcoming)
                      Text(
                        daysUntil == 0
                            ? 'Today!'
                            : daysUntil == 1
                                ? 'Tomorrow'
                                : '$daysUntil days remaining',
                        style: TextStyle(
                          color: AppTheme.warningColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (exam.notes != null) Text(exam.notes!),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    dataProvider.deleteExam(exam.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ----------------------------------------------------
// TO-DO TAB
// ----------------------------------------------------

class _TodosTab extends StatelessWidget {
  const _TodosTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        final todos = dataProvider.todos
          ..sort((a, b) {
            if (a.isCompleted != b.isCompleted) {
              return a.isCompleted ? 1 : -1;
            }
            if (a.dueDate != null && b.dueDate != null) {
              return a.dueDate!.compareTo(b.dueDate!);
            }
            return a.createdAt.compareTo(b.createdAt);
          });

        if (todos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline,
                    size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No tasks yet',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            final isOverdue = !todo.isCompleted &&
                todo.dueDate != null &&
                todo.dueDate!.isBefore(DateTime.now());

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: isOverdue ? Colors.red.shade50 : null,
              child: ListTile(
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    dataProvider.updateTodo(
                      todo.copyWith(isCompleted: value ?? false),
                    );
                  },
                ),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: todo.dueDate != null
                    ? Text(
                        DateFormat('MMM d, y')
                            .format(todo.dueDate!),
                        style: TextStyle(
                          color: isOverdue
                              ? AppTheme.errorColor
                              : AppTheme.textSecondary,
                        ),
                      )
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (todo.isRepeating)
                      const Icon(Icons.repeat, size: 20),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        dataProvider.deleteTodo(todo.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
