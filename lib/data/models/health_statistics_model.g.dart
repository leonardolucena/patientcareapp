// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_statistics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthMetricModelAdapter extends TypeAdapter<HealthMetricModel> {
  @override
  final int typeId = 10;

  @override
  HealthMetricModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthMetricModel(
      id: fields[0] as String,
      type: fields[1] as HealthMetricType,
      value: fields[2] as double? ?? 0.0,
      unit: fields[3] as String,
      date: fields[4] as DateTime,
      notes: fields[5] as String?,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthMetricModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthMetricModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthStatisticsModelAdapter extends TypeAdapter<HealthStatisticsModel> {
  @override
  final int typeId = 11;

  @override
  HealthStatisticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthStatisticsModel(
      id: fields[0] as String,
      metricType: fields[1] as HealthMetricType,
      currentValue: fields[2] as double? ?? 0.0,
      averageValue: fields[3] as double? ?? 0.0,
      minValue: fields[4] as double? ?? 0.0,
      maxValue: fields[5] as double? ?? 0.0,
      unit: fields[6] as String,
      periodStart: fields[7] as DateTime,
      periodEnd: fields[8] as DateTime,
      totalMeasurements: fields[9] as int? ?? 0,
      trend: fields[10] as String?,
      trendPercentage: fields[11] as double?,
      createdAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HealthStatisticsModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.metricType)
      ..writeByte(2)
      ..write(obj.currentValue)
      ..writeByte(3)
      ..write(obj.averageValue)
      ..writeByte(4)
      ..write(obj.minValue)
      ..writeByte(5)
      ..write(obj.maxValue)
      ..writeByte(6)
      ..write(obj.unit)
      ..writeByte(7)
      ..write(obj.periodStart)
      ..writeByte(8)
      ..write(obj.periodEnd)
      ..writeByte(9)
      ..write(obj.totalMeasurements)
      ..writeByte(10)
      ..write(obj.trend)
      ..writeByte(11)
      ..write(obj.trendPercentage)
      ..writeByte(12)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthStatisticsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
