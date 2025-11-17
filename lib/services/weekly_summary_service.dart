import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_service.dart';
import 'notification_service.dart';
import '../models/weekly_summary.dart';

class WeeklySummaryService {
  final DataService _dataService = DataService();
  final NotificationService _notificationService = NotificationService();
  static const String _lastSummaryKey = 'last_weekly_summary_date';

  /// Check if weekly summary should be generated and sent
  /// Call this on app startup or periodically
  Future<void> checkAndGenerateWeeklySummary() async {
    try {
      final now = DateTime.now();
      
      // Check if it's Sunday (weekday 7)
      if (now.weekday != 7) {
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final lastSummaryString = prefs.getString(_lastSummaryKey);
      
      if (lastSummaryString != null) {
        final lastSummary = DateTime.parse(lastSummaryString);
        // Check if we already generated summary today
        if (lastSummary.year == now.year &&
            lastSummary.month == now.month &&
            lastSummary.day == now.day) {
          return;
        }
      }

      // Generate and save summary
      final summary = await _dataService.generateWeeklySummary();
      
      // Save the date
      await prefs.setString(_lastSummaryKey, now.toIso8601String());

      // Send notification
      await _sendWeeklySummaryNotification(summary);

      debugPrint('Weekly summary generated: ${summary.productivityScore}');
    } catch (e) {
      debugPrint('Error generating weekly summary: $e');
    }
  }

  Future<void> _sendWeeklySummaryNotification(WeeklySummary summary) async {
    final message = '''
📊 Weekly Summary

✅ LeetCode: ${summary.leetCodeProblemsSolved} problems
📝 Assignments: ${summary.assignmentsCompleted} completed
✓ Tasks: ${summary.tasksCompleted} completed
📌 Notes: ${summary.notesAdded} added

🎯 Productivity Score: ${summary.productivityScore.toStringAsFixed(0)}/100
''';

    // Schedule notification for Sunday at 9 AM
    final now = DateTime.now();
    var notificationTime = DateTime(now.year, now.month, now.day, 9, 0);
    
    // If it's already past 9 AM, schedule for next week
    if (now.hour >= 9) {
      notificationTime = notificationTime.add(const Duration(days: 7));
    }

    await _notificationService.scheduleWeeklySummaryNotification(
      message,
      notificationTime,
    );
  }
}

