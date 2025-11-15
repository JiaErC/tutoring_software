import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'info_controller.g.dart';

class InfoController = _InfoController with _$InfoController;

abstract class _InfoController with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
