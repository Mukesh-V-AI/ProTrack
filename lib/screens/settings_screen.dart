import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, _) {
          final preferences = dataProvider.preferences;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'LeetCode Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Daily Goal'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: preferences.dailyLeetCodeGoal.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: '${preferences.dailyLeetCodeGoal} problems',
                              onChanged: (value) {
                                dataProvider.updatePreferences(
                                  preferences.copyWith(
                                    dailyLeetCodeGoal: value.toInt(),
                                  ),
                                );
                              },
                            ),
                          ),
                          Text(
                            '${preferences.dailyLeetCodeGoal}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Weekly Goal'),
                        subtitle: const Text('Set goal for entire week'),
                        value: preferences.weeklyGoal,
                        onChanged: (value) {
                          dataProvider.updatePreferences(
                            preferences.copyWith(weeklyGoal: value),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: const Text('Enable Reminders'),
                        subtitle: const Text('Get daily LeetCode reminders'),
                        value: preferences.leetCodeRemindersEnabled,
                        onChanged: (value) {
                          dataProvider.updatePreferences(
                            preferences.copyWith(
                              leetCodeRemindersEnabled: value,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Profile'),
                      subtitle: Text(
                        Provider.of<AuthProvider>(context, listen: false)
                                .user
                                ?.email ??
                            'Not available',
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: AppTheme.errorColor),
                      title: const Text(
                        'Sign Out',
                        style: TextStyle(color: AppTheme.errorColor),
                      ),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text('Are you sure you want to sign out?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.errorColor,
                                ),
                                child: const Text('Sign Out'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          await Provider.of<AuthProvider>(context, listen: false)
                              .signOut();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

