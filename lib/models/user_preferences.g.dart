// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final int typeId = 5;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferences(
      dailyLeetCodeGoal: fields[0] as int,
      weeklyGoal: fields[1] as bool,
      leetCodeRemindersEnabled: fields[2] as bool,
      lastWeeklySummary: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dailyLeetCodeGoal)
      ..writeByte(1)
      ..write(obj.weeklyGoal)
      ..writeByte(2)
      ..write(obj.leetCodeRemindersEnabled)
      ..writeByte(3)
      ..write(obj.lastWeeklySummary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
