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
      uID: fields[0] as String,
      uName: fields[1] as String,
      uEmail: fields[2] == null ? '' : fields[2] as String,
      uPhone: fields[3] == null ? '' : fields[3] as String,
      uGender: fields[4] == null ? '隐藏' : fields[4] as String,
      uBirthday: fields[5] == null ? '2000 1 1' : fields[5] as String,
      uPassword: fields[9] as String,
      uRole: fields[6] == null ? '学生' : fields[6] as String,
      uTeachSubjects:
          fields[7] == null ? {} : (fields[7] as Map).cast<String, dynamic>(),
      uStudySubjects:
          fields[8] == null ? {} : (fields[8] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserDataItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.uID)
      ..writeByte(1)
      ..write(obj.uName)
      ..writeByte(2)
      ..write(obj.uEmail)
      ..writeByte(3)
      ..write(obj.uPhone)
      ..writeByte(4)
      ..write(obj.uGender)
      ..writeByte(5)
      ..write(obj.uBirthday)
      ..writeByte(6)
      ..write(obj.uRole)
      ..writeByte(7)
      ..write(obj.uTeachSubjects)
      ..writeByte(8)
      ..write(obj.uStudySubjects)
      ..writeByte(9)
      ..write(obj.uPassword);
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
