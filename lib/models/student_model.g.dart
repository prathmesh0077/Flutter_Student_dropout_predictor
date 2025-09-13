// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 0;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      name: fields[0] as String,
      attendance: fields[1] as double,
      marks: fields[2] as double,
      feesPaid: fields[3] as bool,
      guardianPhone: fields[4] as String,
      lastUpdated: fields[5] as DateTime,
      weeklySnapshots: (fields[6] as List).cast<WeeklySnapshot>(),
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.attendance)
      ..writeByte(2)
      ..write(obj.marks)
      ..writeByte(3)
      ..write(obj.feesPaid)
      ..writeByte(4)
      ..write(obj.guardianPhone)
      ..writeByte(5)
      ..write(obj.lastUpdated)
      ..writeByte(6)
      ..write(obj.weeklySnapshots);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeeklySnapshotAdapter extends TypeAdapter<WeeklySnapshot> {
  @override
  final int typeId = 1;

  @override
  WeeklySnapshot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeeklySnapshot(
      attendance: fields[0] as double,
      marks: fields[1] as double,
      feesPaid: fields[2] as bool,
      weekDate: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WeeklySnapshot obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.attendance)
      ..writeByte(1)
      ..write(obj.marks)
      ..writeByte(2)
      ..write(obj.feesPaid)
      ..writeByte(3)
      ..write(obj.weekDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklySnapshotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RiskCategoryAdapter extends TypeAdapter<RiskCategory> {
  @override
  final int typeId = 2;

  @override
  RiskCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RiskCategory.High;
      case 1:
        return RiskCategory.Medium;
      case 2:
        return RiskCategory.Low;
      default:
        return RiskCategory.High;
    }
  }

  @override
  void write(BinaryWriter writer, RiskCategory obj) {
    switch (obj) {
      case RiskCategory.High:
        writer.writeByte(0);
        break;
      case RiskCategory.Medium:
        writer.writeByte(1);
        break;
      case RiskCategory.Low:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiskCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
