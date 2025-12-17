// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutSessionModelAdapter extends TypeAdapter<WorkoutSessionModel> {
  @override
  final int typeId = 2;

  @override
  WorkoutSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSessionModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      exercises: (fields[2] as List).cast<WorkoutExerciseModel>(),
      xpEarned: fields[3] as int,
      isCompleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSessionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.exercises)
      ..writeByte(3)
      ..write(obj.xpEarned)
      ..writeByte(4)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
