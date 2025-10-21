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
      userID: fields[0] as int,
      userName: fields[1] as String,
      userAvatar:
          fields[2] == null ? '../../data/images/1.png' : fields[2] as String,
      userEmail: fields[3] == null ? '' : fields[3] as String,
      userPhone: fields[4] == null ? '' : fields[4] as String,
      userGender: fields[5] == null ? '隐藏' : fields[5] as String,
      userBirthday: fields[6] == null ? '2000 1 1' : fields[6] as String,
      userSignature: fields[7] == null ? '这里什么都没有' : fields[7] as String,
      userLocation: fields[8] == null ? '' : fields[8] as String,
      userCharacter: fields[9] == null ? '学生' : fields[9] as String,
      subjectsTaught: fields[10] == null
          ? []
          : (fields[10] as List)
              .map((dynamic e) => (e as Map).cast<String, dynamic>())
              .toList(),
      subjectsStudied: fields[11] == null
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
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.userAvatar)
      ..writeByte(3)
      ..write(obj.userEmail)
      ..writeByte(4)
      ..write(obj.userPhone)
      ..writeByte(5)
      ..write(obj.userGender)
      ..writeByte(6)
      ..write(obj.userBirthday)
      ..writeByte(7)
      ..write(obj.userSignature)
      ..writeByte(8)
      ..write(obj.userLocation)
      ..writeByte(9)
      ..write(obj.userCharacter)
      ..writeByte(10)
      ..write(obj.subjectsTaught)
      ..writeByte(11)
      ..write(obj.subjectsStudied)
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
