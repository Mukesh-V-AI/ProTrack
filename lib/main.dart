import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/data_provider.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/weekly_summary_service.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation.dart';
import 'utils/theme.dart';
import 'utils/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with platform-specific config
  await initializeFirebase();
  
  // Initialize local storage
  final storageService = StorageService();
  await storageService.initLocalStorage();
  
  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  // Check for weekly summary (runs in background)
  final weeklySummaryService = WeeklySummaryService();
  weeklySummaryService.checkAndGenerateWeeklySummary();
  
  runApp(const EngiTrackApp());
}

class EngiTrackApp extends StatelessWidget {
  const EngiTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        title: 'EngiTrack',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return const MainNavigation();
        }
        return const AuthScreen();
      },
    );
  }
}
