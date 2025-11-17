import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/assignment.dart';
import '../models/exam.dart';
import '../models/leetcode_entry.dart';
import '../models/note.dart';
import '../models/todo.dart';
import '../models/user_preferences.dart';

class StorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  // Local Storage (Hive)
  Future<void> initLocalStorage() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LeetCodeEntryAdapter());
    Hive.registerAdapter(AssignmentAdapter());
    Hive.registerAdapter(ExamAdapter());
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(UserPreferencesAdapter());
  }

  // LeetCode Entries
  Future<void> saveLeetCodeEntry(LeetCodeEntry entry) async {
    if (userId == null) return;

    // Local
    final box = await Hive.openBox<LeetCodeEntry>('leetcode_entries');
    await box.put(entry.id, entry);

    // Cloud
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('leetcode_entries')
        .doc(entry.id)
        .set(entry.toJson());
  }

  Future<List<LeetCodeEntry>> getLeetCodeEntries() async {
    if (userId == null) return [];

    try {
      // Try cloud first
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('leetcode_entries')
          .get();

      return snapshot.docs
          .map((doc) => LeetCodeEntry.fromJson(doc.data()))
          .toList();
    } catch (e) {
      // Fallback to local
      final box = await Hive.openBox<LeetCodeEntry>('leetcode_entries');
      return box.values.toList();
    }
  }

  // Assignments
  Future<void> saveAssignment(Assignment assignment) async {
    if (userId == null) return;

    final box = await Hive.openBox<Assignment>('assignments');
    await box.put(assignment.id, assignment);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('assignments')
        .doc(assignment.id)
        .set(assignment.toJson());
  }

  Future<List<Assignment>> getAssignments() async {
    if (userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('assignments')
          .get();

      return snapshot.docs
          .map((doc) => Assignment.fromJson(doc.data()))
          .toList();
    } catch (e) {
      final box = await Hive.openBox<Assignment>('assignments');
      return box.values.toList();
    }
  }

  Future<void> deleteAssignment(String id) async {
    if (userId == null) return;

    final box = await Hive.openBox<Assignment>('assignments');
    await box.delete(id);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('assignments')
        .doc(id)
        .delete();
  }

  // Exams
  Future<void> saveExam(Exam exam) async {
    if (userId == null) return;

    final box = await Hive.openBox<Exam>('exams');
    await box.put(exam.id, exam);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('exams')
        .doc(exam.id)
        .set(exam.toJson());
  }

  Future<List<Exam>> getExams() async {
    if (userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('exams')
          .get();

      return snapshot.docs.map((doc) => Exam.fromJson(doc.data())).toList();
    } catch (e) {
      final box = await Hive.openBox<Exam>('exams');
      return box.values.toList();
    }
  }

  Future<void> deleteExam(String id) async {
    if (userId == null) return;

    final box = await Hive.openBox<Exam>('exams');
    await box.delete(id);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('exams')
        .doc(id)
        .delete();
  }

  // Todos
  Future<void> saveTodo(Todo todo) async {
    if (userId == null) return;

    final box = await Hive.openBox<Todo>('todos');
    await box.put(todo.id, todo);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todo.id)
        .set(todo.toJson());
  }

  Future<List<Todo>> getTodos() async {
    if (userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('todos')
          .get();

      return snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList();
    } catch (e) {
      final box = await Hive.openBox<Todo>('todos');
      return box.values.toList();
    }
  }

  Future<void> deleteTodo(String id) async {
    if (userId == null) return;

    final box = await Hive.openBox<Todo>('todos');
    await box.delete(id);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(id)
        .delete();
  }

  // Notes
  Future<void> saveNote(Note note) async {
    if (userId == null) return;

    final box = await Hive.openBox<Note>('notes');
    await box.put(note.id, note);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(note.id)
        .set(note.toJson());
  }

  Future<List<Note>> getNotes() async {
    if (userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notes')
          .get();

      return snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
    } catch (e) {
      final box = await Hive.openBox<Note>('notes');
      return box.values.toList();
    }
  }

  Future<void> deleteNote(String id) async {
    if (userId == null) return;

    final box = await Hive.openBox<Note>('notes');
    await box.delete(id);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(id)
        .delete();
  }

  // User Preferences
  Future<void> saveUserPreferences(UserPreferences preferences) async {
    if (userId == null) return;

    final box = await Hive.openBox<UserPreferences>('user_preferences');
    await box.put('preferences', preferences);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('user_preferences')
        .set(preferences.toJson());
  }

  Future<UserPreferences> getUserPreferences() async {
    if (userId == null) return UserPreferences();

    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('user_preferences')
          .get();

      if (doc.exists) {
        return UserPreferences.fromJson(doc.data()!);
      }
    } catch (e) {
      // Fallback to local
    }

    final box = await Hive.openBox<UserPreferences>('user_preferences');
    return box.get('preferences') ?? UserPreferences();
  }
}

