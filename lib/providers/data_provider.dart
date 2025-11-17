import 'package:flutter/foundation.dart';
import '../models/assignment.dart';
import '../models/exam.dart';
import '../models/leetcode_entry.dart';
import '../models/note.dart';
import '../models/todo.dart';
import '../models/user_preferences.dart';
import '../models/weekly_summary.dart';
import '../services/data_service.dart';

class DataProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  List<LeetCodeEntry> _leetcodeEntries = [];
  List<Assignment> _assignments = [];
  List<Exam> _exams = [];
  List<Todo> _todos = [];
  List<Note> _notes = [];
  UserPreferences _preferences = UserPreferences();
  WeeklySummary? _weeklySummary;

  List<LeetCodeEntry> get leetcodeEntries => _leetcodeEntries;
  List<Assignment> get assignments => _assignments;
  List<Exam> get exams => _exams;
  List<Todo> get todos => _todos;
  List<Note> get notes => _notes;
  UserPreferences get preferences => _preferences;
  WeeklySummary? get weeklySummary => _weeklySummary;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _leetcodeEntries = await _dataService.getLeetCodeEntries();
      _assignments = await _dataService.getAssignments();
      _exams = await _dataService.getExams();
      _todos = await _dataService.getTodos();
      _notes = await _dataService.getNotes();
      _preferences = await _dataService.getUserPreferences();
      _weeklySummary = await _dataService.generateWeeklySummary();
    } catch (e) {
      debugPrint('Error loading data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // LeetCode
  Future<void> addLeetCodeEntry(int problemsSolved, {String? notes}) async {
    await _dataService.addLeetCodeEntry(problemsSolved, notes: notes);
    await loadAllData();
  }

  int getTodayProblemsSolved() {
    return _dataService.getTodayProblemsSolved(_leetcodeEntries);
  }

  int getWeeklyStreak() {
    return _dataService.getWeeklyStreak(_leetcodeEntries);
  }

  Map<DateTime, int> getMonthlyConsistency() {
    return _dataService.getMonthlyConsistency(_leetcodeEntries);
  }

  // Assignments
  Future<void> addAssignment({
    required String name,
    required String subject,
    required DateTime dueDate,
    String? description,
  }) async {
    await _dataService.addAssignment(
      name: name,
      subject: subject,
      dueDate: dueDate,
      description: description,
    );
    await loadAllData();
  }

  Future<void> updateAssignment(Assignment assignment) async {
    await _dataService.updateAssignment(assignment);
    await loadAllData();
  }

  Future<void> deleteAssignment(String id) async {
    await _dataService.deleteAssignment(id);
    await loadAllData();
  }

  List<Assignment> getUpcomingAssignments() {
    final now = DateTime.now();
    return _assignments
        .where((a) => !a.isCompleted && a.dueDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Exams
  Future<void> addExam({
    required String name,
    required DateTime dateTime,
    String? notes,
  }) async {
    await _dataService.addExam(name: name, dateTime: dateTime, notes: notes);
    await loadAllData();
  }

  Future<void> updateExam(Exam exam) async {
    await _dataService.updateExam(exam);
    await loadAllData();
  }

  Future<void> deleteExam(String id) async {
    await _dataService.deleteExam(id);
    await loadAllData();
  }

  List<Exam> getUpcomingExams() {
    final now = DateTime.now();
    return _exams.where((e) => e.dateTime.isAfter(now)).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  // Todos
  Future<void> addTodo({
    required String title,
    DateTime? dueDate,
    bool isRepeating = false,
    String? repeatPattern,
  }) async {
    await _dataService.addTodo(
      title: title,
      dueDate: dueDate,
      isRepeating: isRepeating,
      repeatPattern: repeatPattern,
    );
    await loadAllData();
  }

  Future<void> updateTodo(Todo todo) async {
    await _dataService.updateTodo(todo);
    await loadAllData();
  }

  Future<void> deleteTodo(String id) async {
    await _dataService.deleteTodo(id);
    await loadAllData();
  }

  List<Todo> getIncompleteTodos() {
    return _todos.where((t) => !t.isCompleted).toList();
  }

  // Notes
  Future<void> addNote({
    required String title,
    required String description,
  }) async {
    await _dataService.addNote(title: title, description: description);
    await loadAllData();
  }

  Future<void> updateNote(Note note) async {
    await _dataService.updateNote(note);
    await loadAllData();
  }

  Future<void> deleteNote(String id) async {
    await _dataService.deleteNote(id);
    await loadAllData();
  }

  List<Note> getSortedNotes() {
    final sorted = List<Note>.from(_notes);
    sorted.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return sorted;
  }

  // Preferences
  Future<void> updatePreferences(UserPreferences preferences) async {
    await _dataService.saveUserPreferences(preferences);
    _preferences = preferences;
    notifyListeners();
  }

  // Weekly Summary
  Future<void> refreshWeeklySummary() async {
    _weeklySummary = await _dataService.generateWeeklySummary();
    notifyListeners();
  }
}

