// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leetcode_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeetCodeEntryAdapter extends TypeAdapter<LeetCodeEntry> {
  @override
  final int typeId = 0;

  @override
  LeetCodeEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LeetCodeEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      problemsSolved: fields[2] as int,
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LeetCodeEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.problemsSolved)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeetCodeEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
