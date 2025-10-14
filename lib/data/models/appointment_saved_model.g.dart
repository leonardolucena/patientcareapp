// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_saved_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentSavedModelAdapter extends TypeAdapter<AppointmentSavedModel> {
  @override
  final int typeId = 1;

  @override
  AppointmentSavedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentSavedModel(
      id: fields[0] as String,
      doctorName: fields[1] as String,
      specialty: fields[2] as String,
      clinicName: fields[3] as String,
      consultationType: fields[4] as String,
      date: fields[5] as String,
      time: fields[6] as String,
      priority: fields[7] as String,
      paymentMethod: fields[8] as String,
      createdAt: fields[9] as DateTime,
      isCompleted: (fields[10] as bool?) ?? false,
      completedAt: fields[11] as DateTime?,
      isCancelled: (fields[12] as bool?) ?? false,
      cancelledAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AppointmentSavedModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.doctorName)
      ..writeByte(2)
      ..write(obj.specialty)
      ..writeByte(3)
      ..write(obj.clinicName)
      ..writeByte(4)
      ..write(obj.consultationType)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(8)
      ..write(obj.paymentMethod)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.isCompleted)
      ..writeByte(11)
      ..write(obj.completedAt)
      ..writeByte(12)
      ..write(obj.isCancelled)
      ..writeByte(13)
      ..write(obj.cancelledAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentSavedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
