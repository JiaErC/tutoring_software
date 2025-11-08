import 'package:hive/hive.dart';

part 'phone_number_item.g.dart';

@HiveType(typeId:2)
class PhoneNumberItem{
  @HiveField(0)
  late int phoneNumber;
  @HiveField(1)
  late String uID;

   PhoneNumberItem(this.phoneNumber,this.uID);

   @override
   String toString(){
     return "PhoneNumber: $phoneNumber, uID: $uID";
   }
}