import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'avatar_item.g.dart';

@HiveType(typeId: 2) // 确保typeId不与其他模型冲突
class AvatarItem {
  @HiveField(1)
  late Uint8List imageData; // 使用List<int>存储Uint8List类型的图片数据
  //这个是图片类型
  @HiveField(2)
  late String mimeType;

  AvatarItem({required this.imageData, required this.mimeType});

  // 从Map创建实例
  AvatarItem.fromMap(Map<String, dynamic> map) {
    imageData = Uint8List.fromList(map['imageData']);
    mimeType = map['mimeType'];
  }

  // 转换为Map
  Map<String, dynamic> toMap() {
    return {'imageData': imageData, 'mimeType': mimeType};
  }
}
