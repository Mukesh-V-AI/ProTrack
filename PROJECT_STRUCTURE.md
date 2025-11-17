# EngiTrack Project Structure

## Overview

EngiTrack is a Flutter-based student productivity app with a clean, minimal UI focused on consistency tracking and task management.

## Architecture

### State Management
- **Provider**: Used for state management across the app
- **AuthProvider**: Manages authentication state
- **DataProvider**: Manages all app data (assignments, exams, todos, notes, LeetCode entries)

### Data Layer

#### Models (`lib/models/`)
- `leetcode_entry.dart`: LeetCode problem tracking entries
- `assignment.dart`: Assignment data model
- `exam.dart`: Exam data model
- `todo.dart`: Todo task model
- `note.dart`: Note model
- `user_preferences.dart`: User settings and preferences
- `weekly_summary.dart`: Weekly productivity summary

#### Services (`lib/services/`)
- `auth_service.dart`: Firebase authentication (Email/Google)
- `storage_service.dart`: Hybrid storage (Hive local + Firestore cloud)
- `notification_service.dart`: Local notifications for reminders
- `data_service.dart`: Business logic for all data operations

### UI Layer

#### Screens (`lib/screens/`)
- `auth_screen.dart`: Login/Signup screen
- `home_screen.dart`: Main dashboard with streaks, deadlines, summary
- `tasks_screen.dart`: Tabbed view for Assignments, Exams, Todos
- `notes_screen.dart`: Notes list with pin/sort functionality
- `settings_screen.dart`: User preferences and account settings
- `main_navigation.dart`: Bottom navigation wrapper

#### Widgets (`lib/widgets/`)
- `leetcode_tracker_card.dart`: LeetCode progress card
- `upcoming_deadlines_card.dart`: Upcoming assignments/exams
- `weekly_summary_card.dart`: Weekly productivity summary
- `add_leetcode_dialog.dart`: Dialog to add LeetCode entry
- `add_assignment_dialog.dart`: Dialog to add assignment
- `add_exam_dialog.dart`: Dialog to add exam
- `add_todo_dialog.dart`: Dialog to add todo
- `add_note_dialog.dart`: Dialog to add/edit note

### Utilities (`lib/utils/`)
- `theme.dart`: App theme and color palette

## Data Flow

1. **User Action** → UI Widget
2. **UI Widget** → DataProvider method
3. **DataProvider** → DataService method
4. **DataService** → StorageService (save to local + cloud)
5. **StorageService** → Hive (local) + Firestore (cloud)
6. **DataProvider** → Notify listeners
7. **UI** → Rebuild with new data

## Features Implementation

### LeetCode Tracker
- Daily goal setting (Settings)
- Entry tracking (Add entry dialog)
- Streak calculation (consecutive days with problems solved)
- Monthly consistency chart (data available in DataService)

### Assignment Tracker
- CRUD operations
- Automatic reminder scheduling (3 days, 1 day, on day)
- Subject categorization
- Due date tracking

### Exam Tracker
- CRUD operations
- Date & time scheduling
- Automatic reminder scheduling (1 week, 3 days, 1 day)
- Notes field for hall tickets, syllabus, etc.

### Todo List
- Simple task management
- Optional due dates
- Repeating tasks (daily, weekly, monthly)
- Checkbox interface

### Notes
- Title + description
- Pin functionality
- Sort by time or pinned status
- Edit/delete operations

### Weekly Summary
- Generated automatically
- Calculates productivity score (0-100)
- Shows LeetCode problems, assignments, tasks, notes
- Available in Home screen

## Storage Strategy

### Local (Hive)
- Fast access
- Offline support
- Primary storage for immediate UI updates

### Cloud (Firestore)
- Cross-device sync
- Backup
- Syncs when online

### Sync Logic
- On save: Write to both local and cloud
- On load: Try cloud first, fallback to local
- Automatic sync when online

## Notification System

### Scheduled Notifications
- Daily LeetCode reminders (configurable time)
- Assignment reminders (3 days, 1 day, on day)
- Exam reminders (1 week, 3 days, 1 day)

### Implementation
- Uses `flutter_local_notifications`
- Timezone-aware scheduling
- Platform-specific (Android/iOS)

## Security

- Firebase Authentication for user management
- Firestore security rules (should be configured)
- Local data encrypted by Hive
- No sensitive data in code

## Future Enhancements (Not Implemented)

- Monthly consistency chart visualization
- Weekly summary email/export
- Dark mode
- Custom themes
- Data export/import
- Collaboration features

