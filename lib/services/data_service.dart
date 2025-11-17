import 'package:uuid/uuid.dart';
import '../models/assignment.dart';
import '../models/exam.dart';
import '../models/leetcode_entry.dart';
import '../models/note.dart';
import '../models/todo.dart';
import '../models/user_preferences.dart';
import '../models/weekly_summary.dart';
import 'storage_service.dart';
import 'notification_service.dart';

class DataService {
  final StorageService _storage = StorageService();
  final NotificationService _notifications = NotificationService();
  final _uuid = const Uuid();

  // LeetCode
  Future<void> addLeetCodeEntry(int problemsSolved, {String? notes}) async {
    final entry = LeetCodeEntry(
      id: _uuid.v4(),
      date: DateTime.now(),
      problemsSolved: problemsSolved,
      notes: notes,
    );
    await _storage.saveLeetCodeEntry(entry);
  }

  Future<List<LeetCodeEntry>> getLeetCodeEntries() async {
    return await _storage.getLeetCodeEntries();
  }

  int getTodayProblemsSolved(List<LeetCodeEntry> entries) {
    final today = DateTime.now();
    final todayEntry = entries.firstWhere(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
      orElse: () => LeetCodeEntry(
        id: '',
        date: today,
        problemsSolved: 0,
      ),
    );
    return todayEntry.problemsSolved;
  }

  int getWeeklyStreak(List<LeetCodeEntry> entries) {
    if (entries.isEmpty) return 0;

    final sorted = List<LeetCodeEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    DateTime currentDate = DateTime.now();
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

    for (var entry in sorted) {
      final entryDate =
          DateTime(entry.date.year, entry.date.month, entry.date.day);
      final daysDiff = currentDate.difference(entryDate).inDays;

      if (daysDiff == streak && entry.problemsSolved > 0) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (daysDiff > streak) {
        break;
      }
    }

    return streak;
  }

  Map<DateTime, int> getMonthlyConsistency(List<LeetCodeEntry> entries) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final Map<DateTime, int> consistency = {};

    for (var entry in entries) {
      if (entry.date.isAfter(startOfMonth) || entry.date.isAtSameMomentAs(startOfMonth)) {
        final day = DateTime(entry.date.year, entry.date.month, entry.date.day);
        consistency[day] = (consistency[day] ?? 0) + entry.problemsSolved;
      }
    }

    return consistency;
  }

  // Assignments
  Future<void> addAssignment({
    required String name,
    required String subject,
    required DateTime dueDate,
    String? description,
  }) async {
    final assignment = Assignment(
      id: _uuid.v4(),
      name: name,
      subject: subject,
      dueDate: dueDate,
      description: description,
      createdAt: DateTime.now(),
    );

    await _storage.saveAssignment(assignment);

    // Schedule reminders
    await _notifications.scheduleAssignmentReminder(name, dueDate, 3);
    await _notifications.scheduleAssignmentReminder(name, dueDate, 1);
    await _notifications.scheduleAssignmentReminder(name, dueDate, 0);
  }

  Future<List<Assignment>> getAssignments() async {
    return await _storage.getAssignments();
  }

  Future<void> updateAssignment(Assignment assignment) async {
    await _storage.saveAssignment(assignment);
  }

  Future<void> deleteAssignment(String id) async {
    await _storage.deleteAssignment(id);
  }

  // Exams
  Future<void> addExam({
    required String name,
    required DateTime dateTime,
    String? notes,
  }) async {
    final exam = Exam(
      id: _uuid.v4(),
      name: name,
      dateTime: dateTime,
      notes: notes,
      createdAt: DateTime.now(),
    );

    await _storage.saveExam(exam);

    // Schedule reminders
    await _notifications.scheduleExamReminder(name, dateTime, 7);
    await _notifications.scheduleExamReminder(name, dateTime, 3);
    await _notifications.scheduleExamReminder(name, dateTime, 1);
  }

  Future<List<Exam>> getExams() async {
    return await _storage.getExams();
  }

  Future<void> updateExam(Exam exam) async {
    await _storage.saveExam(exam);
  }

  Future<void> deleteExam(String id) async {
    await _storage.deleteExam(id);
  }

  // Todos
  Future<void> addTodo({
    required String title,
    DateTime? dueDate,
    bool isRepeating = false,
    String? repeatPattern,
  }) async {
    final todo = Todo(
      id: _uuid.v4(),
      title: title,
      dueDate: dueDate,
      isRepeating: isRepeating,
      repeatPattern: repeatPattern,
      createdAt: DateTime.now(),
    );

    await _storage.saveTodo(todo);
  }

  Future<List<Todo>> getTodos() async {
    return await _storage.getTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await _storage.saveTodo(todo);
  }

  Future<void> deleteTodo(String id) async {
    await _storage.deleteTodo(id);
  }

  // Notes
  Future<void> addNote({
    required String title,
    required String description,
  }) async {
    final now = DateTime.now();
    final note = Note(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdAt: now,
      updatedAt: now,
    );

    await _storage.saveNote(note);
  }

  Future<List<Note>> getNotes() async {
    return await _storage.getNotes();
  }

  Future<void> updateNote(Note note) async {
    final updated = note.copyWith(updatedAt: DateTime.now());
    await _storage.saveNote(updated);
  }

  Future<void> deleteNote(String id) async {
    await _storage.deleteNote(id);
  }

  // User Preferences
  Future<UserPreferences> getUserPreferences() async {
    return await _storage.getUserPreferences();
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    await _storage.saveUserPreferences(preferences);
  }

  // Weekly Summary
  Future<WeeklySummary> generateWeeklySummary() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final leetCodeEntries = await getLeetCodeEntries();
    final assignments = await getAssignments();
    final todos = await getTodos();
    final notes = await getNotes();

    final weekLeetCode = leetCodeEntries
        .where((e) =>
            e.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            e.date.isBefore(endOfWeek.add(const Duration(days: 1))))
        .fold<int>(0, (sum, e) => sum + e.problemsSolved);

    final weekAssignments = assignments
        .where((a) =>
            a.isCompleted &&
            a.dueDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            a.dueDate.isBefore(endOfWeek.add(const Duration(days: 1))))
        .length;

    final weekTodos = todos
        .where((t) =>
            t.isCompleted &&
            (t.createdAt.isAfter(startOfWeek.subtract(const Duration(days: 1))) ||
                t.dueDate != null &&
                    t.dueDate!
                        .isAfter(startOfWeek.subtract(const Duration(days: 1)))))
        .length;

    final weekNotes = notes
        .where((n) =>
            n.createdAt.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            n.createdAt.isBefore(endOfWeek.add(const Duration(days: 1))))
        .length;

    // Calculate productivity score (0-100)
    final preferences = await _storage.getUserPreferences();
    final expectedLeetCode = preferences.weeklyGoal
        ? preferences.dailyLeetCodeGoal * 7
        : preferences.dailyLeetCodeGoal * 7;

    final leetCodeScore = (weekLeetCode / expectedLeetCode * 50).clamp(0, 50);
    final taskScore = ((weekAssignments + weekTodos) / 10 * 30).clamp(0, 30);
    final notesScore = (weekNotes / 5 * 20).clamp(0, 20);

    final productivityScore = (leetCodeScore + taskScore + notesScore).toDouble();

    return WeeklySummary(
      weekStart: startOfWeek,
      weekEnd: endOfWeek,
      leetCodeProblemsSolved: weekLeetCode,
      assignmentsCompleted: weekAssignments,
      tasksCompleted: weekTodos,
      notesAdded: weekNotes,
      productivityScore: productivityScore,
    );
  }
}

