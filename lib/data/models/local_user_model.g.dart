// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalUserModelAdapter extends TypeAdapter<LocalUserModel> {
  @override
  final int typeId = 0;

  @override
  LocalUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalUserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      passwordHash: fields[2] as String,
      createdAt: fields[3] as DateTime,
      lastLoginAt: fields[4] as DateTime?,
      name: fields[5] as String?,
      age: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalUserModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.passwordHash)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastLoginAt)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.age);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
