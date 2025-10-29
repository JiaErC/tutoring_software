import 'package:hive/hive.dart';

part 'email_item.g.dart';

@HiveType(typeId: 3)
class EmailItem {
  @HiveField(0)
  late String email;
  @HiveField(1)
  late String uID;

  EmailItem(this.email, this.uID);

  @override
  String toString(){
    return "Email: $email, uID: $uID";
  }
}
