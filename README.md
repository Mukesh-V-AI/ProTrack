# EngiTrack

A clean, minimal, and efficient student productivity app for managing day-to-day activities and improving consistency.

## Features

### 🔒 Core Features
- User sign-in (Email or Google)
- Secure private dashboard
- Light, minimal UI
- Local + cloud data sync
- Notification + reminder system

### 📌 Main Features

#### A. LeetCode Consistency Tracker
- Set daily/weekly goals
- Daily reminder notifications
- Track problems solved today
- Weekly streak tracking
- Monthly consistency chart

#### B. Assignment Tracker
- Add assignment with name, subject, due date, and description
- Mark as completed
- Automatic reminders (3 days, 1 day, and on the day)

#### C. Exam Date Tracker
- Add exam with name, date & time, and notes
- Auto reminders (1 week, 3 days, 1 day before)

#### D. Weekly Summary Report
- Automatically generated every Sunday
- Shows LeetCode problems solved, assignments completed, tasks completed, notes added
- Overall productivity score (0-100)
- Available as notification and dashboard view

#### E. Simple To-Do List
- Add tasks with optional due dates
- Mark as complete
- Support for repeating tasks (daily, weekly, monthly)
- Clean checkbox interface

#### F. Quick Notes
- Add short notes with title and description
- Pin important notes
- Sort by time or pinned status

## Setup Instructions

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Firebase project set up
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd engitrack
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google Sign-In)
   - Enable Cloud Firestore
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Docker Deployment (Web)

EngiTrack can be deployed as a web application using Docker. See [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md) for detailed instructions.

### Quick Start with Docker

**Windows:**
```bash
deploy.bat run
```

**Linux/Mac:**
```bash
./deploy.sh run
```

**Or using Docker Compose:**
```bash
docker-compose up -d --build
```

The app will be available at `http://localhost:8080`

### Before Deploying

1. **Configure Firebase for Web:**
   - Add a web app in Firebase Console
   - Update `lib/utils/firebase_config.dart` with your Firebase web config
   - See [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md) for details

2. **Build and Deploy:**
   ```bash
   # Build image
   docker build -t engitrack:latest .
   
   # Run container
   docker run -d -p 8080:80 engitrack:latest
   ```

## Project Structure

```
lib/
├── models/          # Data models (LeetCodeEntry, Assignment, Exam, Todo, Note, etc.)
├── services/        # Business logic (Auth, Storage, Notifications, Data)
├── providers/       # State management (AuthProvider, DataProvider)
├── screens/         # UI screens (Auth, Home, Tasks, Notes, Settings)
├── widgets/         # Reusable UI components
└── utils/           # Utilities (Theme, constants)
```

## Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore + Hive (local storage)
- **Notifications**: flutter_local_notifications
- **Charts**: fl_chart

## UI Design

- **Tabs**: Home | Tasks | Notes
- **Color Palette**: White + pastel colors
- **Theme**: Light, minimal, clean layout

## Data Sync

The app uses a hybrid approach:
- **Local Storage**: Hive for offline access and fast loading
- **Cloud Sync**: Firebase Firestore for cross-device synchronization
- Data is automatically synced when online

## Notifications

The app schedules notifications for:
- Daily LeetCode reminders
- Assignment due dates (3 days, 1 day, on the day)
- Exam dates (1 week, 3 days, 1 day before)

## Weekly Summary

Generated automatically every Sunday, showing:
- LeetCode problems solved
- Assignments completed
- Tasks completed
- Notes added
- Productivity score (0-100)

## License

This project is private and not intended for public distribution.
