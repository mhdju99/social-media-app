// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 0;

  @override
  NotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModel(
      actorId: fields[0] as String,
      userName: fields[1] as String,
      profileImage: fields[2] as String,
      text: fields[3] as String,
      date: fields[5] as DateTime,
      postId: fields[4] as String?,
      isRead: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.actorId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.profileImage)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.postId)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
