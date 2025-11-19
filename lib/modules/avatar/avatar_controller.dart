import 'dart:convert';
import 'dart:typed_data';

import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:tutoring_software/utils/storage.dart';
import 'package:tutoring_software/modules/avatar/avatar_item.dart';
import 'package:tutoring_software/modules/api/api_settings.dart';

part 'avatar_controller.g.dart';

class AvatarController = _AvatarController with _$AvatarController;

abstract class _AvatarController with Store {
  final String avatarBaseUrl = '$baseUrl/api/user-avatars';

  //打开头像盒子
  var _avatarItemBox = GStorage.avatarItemBox;

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = '';

  @observable
  Uint8List? avatarData;

  @observable
  String? mimeType;

  /**************后端操作区块************* */
  //初始化方法，用来获取数据
  @action
  Future<void> init(String uid) async {
    AvatarItem? avatarItem = await getAvatarByUid(uid);
    if (avatarItem != null) {
      avatarData = avatarItem.imageData;
      mimeType = avatarItem.mimeType;
    } else {
      isLoading = false;
      avatarItem = null;
      mimeType = '';
    }
    debugPrint('avatar_controller.dart_获取到的头像数据是: $avatarItem');
  }

  @action
  Future<AvatarItem?> getAvatarByUid(String uid) async {
    try {
      // 先从本地存储中获取签名
      final localAvatar = _avatarItemBox.get(uid);
      if (localAvatar != null) {
        debugPrint('从本地存储获取到的头像: $localAvatar');
        return localAvatar;
      }
      //如果本地没有头像，就要从后端获取
      final response = await http.get(
        Uri.parse('$avatarBaseUrl/get/$uid'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200 && result['data'] != null) {
          // 假设后端返回的是base64编码的图片数据
          final imageDataBase64 = result['data']['imageData'];
          avatarData = base64Decode(imageDataBase64);
          mimeType = result['data']['mimeType'];
          // 假设后端返回的是base64编码的图片数据
          final avatarItem = AvatarItem(
            imageData: avatarData!,
            mimeType: mimeType!,
          );
          // 本地存储
          _avatarItemBox.put(uid, avatarItem);
          return avatarItem;
        } else {
          debugPrint('avatar_controller.dart_获取头像失败: ${result['message']}');
          return null;
        }
      } else {
        debugPrint('avatar_controller.dart_获取头像失败，状态码: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('avatar_controller.dart_获取头像失败: $e');
      return null;
    }
  }

  //存储头像
  @action
  Future<bool> saveAvatar(
    String uid,
    Uint8List imageData,
    String mimeType,
  ) async {
    try {
      //先检查这个图片是否存在
      AvatarItem? existingAvatar = await getAvatarByUid(uid);
      if (existingAvatar != null) {
        //如果存在，就更新
        return await updateAvatar(uid, imageData, mimeType);
      } else {
        final response = await http.post(
          Uri.parse('$avatarBaseUrl/save'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'uid': uid,
            'imageData': base64Encode(imageData),
            'mimeType': mimeType,
          }),
        );

        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['code'] == 200) {
            avatarData = imageData;
            this.mimeType = mimeType;
            //本地存储
            _avatarItemBox.put(
              uid,
              AvatarItem(imageData: imageData, mimeType: mimeType),
            );
            isLoading = true;
            debugPrint('avatar_controller.dart_保存头像成功');
            return true;
          } else {
            debugPrint('avatar_controller.dart_保存头像失败: ${result['message']}');
            return false;
          }
        } else {
          debugPrint('avatar_controller.dart_服务器错误: ${response.statusCode}');
          return false;
        }
      }
    } catch (e) {
      debugPrint('avatar_controller.dart_网络错误: $e');
      return false;
    }
  }

  //更新头像
  @action
  Future<bool> updateAvatar(
    String uid,
    Uint8List imageData,
    String mimeType,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$avatarBaseUrl/update'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'uid': uid,
          'imageData': base64Encode(imageData),
          'mimeType': mimeType,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] == 200) {
          avatarData = imageData;
          this.mimeType = mimeType;
          // 本地存储
          _avatarItemBox.put(
            uid,
            AvatarItem(imageData: imageData, mimeType: mimeType),
          );
          isLoading = true;
          debugPrint('avatar_controller.dart_更新头像成功');
          return true;
        } else {
          debugPrint('avatar_controller.dart_更新头像失败: ${result['message']}');
          return false;
        }
      } else {
        debugPrint('avatar_controller.dart_服务器错误: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('avatar_controller.dart_网络错误: $e');
      return false;
    }
  }

  // // 注意：后端没有提供删除头像的API，这里提供一个占位方法
  // @action
  // Future<bool> deleteAvatar(String uid) async {
  //   // 由于后端没有提供删除头像的API，这里返回一个提示
  //   errorMessage = '删除功能暂未实现';
  //   return false;
  // }

  // // 辅助方法：清除错误信息
  // @action
  // void clearError() {
  //   errorMessage = '';
  // }

  // // 辅助方法：清除头像数据
  // @action
  // void clearAvatar() {
  //   avatarData = null;
  //   mimeType = null;
  // }

  /**************上传图片，选择图片区块************ */
  Future<void> pickImageFromCamera(String uid) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Uint8List imageData = await image.readAsBytes();
      // 上传头像
      // if (isLoading) {
      //   await saveAvatar(uid, imageData, image.mimeType ?? "image/jpeg");
      // } else {
      //   await updateAvatar(uid, imageData, image.mimeType ?? "image/jpeg");
      // }
      await saveAvatar(uid, imageData, image.mimeType ?? "image/jpeg");
      // await uploadAvatar(await image.readAsBytes(), image.mimeType ?? "image/jpeg");
    }
  }

  Future<void> pickImageFromGallery(String uid) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List imageData = await image.readAsBytes();
      // 上传头像
      // if (isLoading) {
      //   await saveAvatar(uid, imageData, image.mimeType ?? "image/jpeg");
      // } else {
      //   await updateAvatar(uid, imageData, image.mimeType ?? "image/jpeg");
      // }
      await saveAvatar(uid, imageData, image.mimeType ?? "image/jpeg");
      // await _uploadAvatar(await image.readAsBytes(), image.mimeType ?? "image/jpeg");
    }
  }
}
