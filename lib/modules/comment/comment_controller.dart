import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

import 'package:tutoring_software/modules/api/api_settings.dart';

part 'comment_controller.g.dart';

class CommentController = _CommentController with _$CommentController;

abstract class _CommentController with Store {
  @observable
  String comment = '';
}
