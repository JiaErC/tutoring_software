// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataItemAdapter extends TypeAdapter<UserDataItem> {
  @override
  final int typeId = 0;

  @override
  UserDataItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDataItem(
      uID: fields[0] as int,
      uName: fields[1] as String,
      uAvatar:
          fields[2] == null ? '../../data/images/1.png' : fields[2] as String,
      uEmail: fields[3] == null ? '' : fields[3] as String,
      uPhone: fields[4] == null ? '' : fields[4] as String,
      uGender: fields[5] == null ? '隐藏' : fields[5] as String,
      uBirthday: fields[6] == null ? '2000 1 1' : fields[6] as String,
      uSignature: fields[7] == null ? '这里什么都没有' : fields[7] as String,
      uLocation: fields[8] == null ? '' : fields[8] as String,
      uRole: fields[9] == null ? '学生' : fields[9] as String,
      uTeachSubjects: fields[10] == null
          ? []
          : (fields[10] as List)
              .map((dynamic e) => (e as Map).cast<String, dynamic>())
              .toList(),
      uStudySubjects: fields[11] == null
          ? []
          : (fields[11] as List)
              .map((dynamic e) => (e as Map).cast<String, dynamic>())
              .toList(),
    )..contacts = fields[12] == null ? [] : (fields[12] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, UserDataItem obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.uID)
      ..writeByte(1)
      ..write(obj.uName)
      ..writeByte(2)
      ..write(obj.uAvatar)
      ..writeByte(3)
      ..write(obj.uEmail)
      ..writeByte(4)
      ..write(obj.uPhone)
      ..writeByte(5)
      ..write(obj.uGender)
      ..writeByte(6)
      ..write(obj.uBirthday)
      ..writeByte(7)
      ..write(obj.uSignature)
      ..writeByte(8)
      ..write(obj.uLocation)
      ..writeByte(9)
      ..write(obj.uRole)
      ..writeByte(10)
      ..write(obj.uTeachSubjects)
      ..writeByte(11)
      ..write(obj.uStudySubjects)
      ..writeByte(12)
      ..write(obj.contacts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
