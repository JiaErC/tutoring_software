// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegisterController on _RegisterController, Store {
  Computed<bool>? _$isPasswordMatchComputed;

  @override
  bool get isPasswordMatch =>
      (_$isPasswordMatchComputed ??= Computed<bool>(() => super.isPasswordMatch,
              name: '_RegisterController.isPasswordMatch'))
          .value;

  late final _$uNameAtom =
      Atom(name: '_RegisterController.uName', context: context);

  @override
  String get uName {
    _$uNameAtom.reportRead();
    return super.uName;
  }

  @override
  set uName(String value) {
    _$uNameAtom.reportWrite(value, super.uName, () {
      super.uName = value;
    });
  }

  late final _$uEmailAtom =
      Atom(name: '_RegisterController.uEmail', context: context);

  @override
  String get uEmail {
    _$uEmailAtom.reportRead();
    return super.uEmail;
  }

  @override
  set uEmail(String value) {
    _$uEmailAtom.reportWrite(value, super.uEmail, () {
      super.uEmail = value;
    });
  }

  late final _$uPhoneAtom =
      Atom(name: '_RegisterController.uPhone', context: context);

  @override
  String get uPhone {
    _$uPhoneAtom.reportRead();
    return super.uPhone;
  }

  @override
  set uPhone(String value) {
    _$uPhoneAtom.reportWrite(value, super.uPhone, () {
      super.uPhone = value;
    });
  }

  late final _$uPasswordAtom =
      Atom(name: '_RegisterController.uPassword', context: context);

  @override
  String get uPassword {
    _$uPasswordAtom.reportRead();
    return super.uPassword;
  }

  @override
  set uPassword(String value) {
    _$uPasswordAtom.reportWrite(value, super.uPassword, () {
      super.uPassword = value;
    });
  }

  late final _$uGenderAtom =
      Atom(name: '_RegisterController.uGender', context: context);

  @override
  int get uGender {
    _$uGenderAtom.reportRead();
    return super.uGender;
  }

  @override
  set uGender(int value) {
    _$uGenderAtom.reportWrite(value, super.uGender, () {
      super.uGender = value;
    });
  }

  late final _$uBirthdayAtom =
      Atom(name: '_RegisterController.uBirthday', context: context);

  @override
  String get uBirthday {
    _$uBirthdayAtom.reportRead();
    return super.uBirthday;
  }

  @override
  set uBirthday(String value) {
    _$uBirthdayAtom.reportWrite(value, super.uBirthday, () {
      super.uBirthday = value;
    });
  }

  late final _$uRoleAtom =
      Atom(name: '_RegisterController.uRole', context: context);

  @override
  Set<int> get uRole {
    _$uRoleAtom.reportRead();
    return super.uRole;
  }

  @override
  set uRole(Set<int> value) {
    _$uRoleAtom.reportWrite(value, super.uRole, () {
      super.uRole = value;
    });
  }

  late final _$uTeachSubjectsAtom =
      Atom(name: '_RegisterController.uTeachSubjects', context: context);

  @override
  Map<String, dynamic> get uTeachSubjects {
    _$uTeachSubjectsAtom.reportRead();
    return super.uTeachSubjects;
  }

  @override
  set uTeachSubjects(Map<String, dynamic> value) {
    _$uTeachSubjectsAtom.reportWrite(value, super.uTeachSubjects, () {
      super.uTeachSubjects = value;
    });
  }

  late final _$uStudySubjectsAtom =
      Atom(name: '_RegisterController.uStudySubjects', context: context);

  @override
  Map<String, dynamic> get uStudySubjects {
    _$uStudySubjectsAtom.reportRead();
    return super.uStudySubjects;
  }

  @override
  set uStudySubjects(Map<String, dynamic> value) {
    _$uStudySubjectsAtom.reportWrite(value, super.uStudySubjects, () {
      super.uStudySubjects = value;
    });
  }

  late final _$uConfirmPasswordAtom =
      Atom(name: '_RegisterController.uConfirmPassword', context: context);

  @override
  String get uConfirmPassword {
    _$uConfirmPasswordAtom.reportRead();
    return super.uConfirmPassword;
  }

  @override
  set uConfirmPassword(String value) {
    _$uConfirmPasswordAtom.reportWrite(value, super.uConfirmPassword, () {
      super.uConfirmPassword = value;
    });
  }

  late final _$_RegisterControllerActionController =
      ActionController(name: '_RegisterController', context: context);

  @override
  void clearAllData() {
    final _$actionInfo = _$_RegisterControllerActionController.startAction(
        name: '_RegisterController.clearAllData');
    try {
      return super.clearAllData();
    } finally {
      _$_RegisterControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
uName: ${uName},
uEmail: ${uEmail},
uPhone: ${uPhone},
uPassword: ${uPassword},
uGender: ${uGender},
uBirthday: ${uBirthday},
uRole: ${uRole},
uTeachSubjects: ${uTeachSubjects},
uStudySubjects: ${uStudySubjects},
uConfirmPassword: ${uConfirmPassword},
isPasswordMatch: ${isPasswordMatch}
    ''';
  }
}
