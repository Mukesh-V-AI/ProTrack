import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/data_provider.dart';
import '../utils/theme.dart';

class UpcomingDeadlinesCard extends StatelessWidget {
  const UpcomingDeadlinesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        final upcomingAssignments = dataProvider.getUpcomingAssignments().take(3).toList();
        final upcomingExams = dataProvider.getUpcomingExams().take(3).toList();

        if (upcomingAssignments.isEmpty && upcomingExams.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'No upcoming deadlines',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upcoming Deadlines',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (upcomingAssignments.isNotEmpty) ...[
                  ...upcomingAssignments.map((assignment) => _DeadlineItem(
                        icon: Icons.assignment,
                        title: assignment.name,
                        date: assignment.dueDate,
                        color: AppTheme.warningColor,
                      )),
                ],
                if (upcomingExams.isNotEmpty) ...[
                  ...upcomingExams.map((exam) => _DeadlineItem(
                        icon: Icons.event,
                        title: exam.name,
                        date: exam.dateTime,
                        color: AppTheme.errorColor,
                      )),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DeadlineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final DateTime date;
  final Color color;

  const _DeadlineItem({
    required this.icon,
    required this.title,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final daysUntil = date.difference(DateTime.now()).inDays;
    final isToday = daysUntil == 0;
    final isTomorrow = daysUntil == 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  isToday
                      ? 'Today • ${DateFormat('h:mm a').format(date)}'
                      : isTomorrow
                          ? 'Tomorrow • ${DateFormat('h:mm a').format(date)}'
                          : DateFormat('MMM d • h:mm a').format(date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (isToday || isTomorrow)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isToday ? 'Today' : 'Tomorrow',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

