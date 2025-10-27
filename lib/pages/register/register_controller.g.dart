// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegisterController on _RegisterController, Store {
  late final _$usernameAtom =
      Atom(name: '_RegisterController.username', context: context);

  @override
  String get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  late final _$emailAtom =
      Atom(name: '_RegisterController.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: '_RegisterController.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$phoneAtom =
      Atom(name: '_RegisterController.phone', context: context);

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  late final _$genderAtom =
      Atom(name: '_RegisterController.gender', context: context);

  @override
  int get gender {
    _$genderAtom.reportRead();
    return super.gender;
  }

  @override
  set gender(int value) {
    _$genderAtom.reportWrite(value, super.gender, () {
      super.gender = value;
    });
  }

  late final _$birthdayAtom =
      Atom(name: '_RegisterController.birthday', context: context);

  @override
  String get birthday {
    _$birthdayAtom.reportRead();
    return super.birthday;
  }

  @override
  set birthday(String value) {
    _$birthdayAtom.reportWrite(value, super.birthday, () {
      super.birthday = value;
    });
  }

  late final _$roleAtom =
      Atom(name: '_RegisterController.role', context: context);

  @override
  Set<int> get role {
    _$roleAtom.reportRead();
    return super.role;
  }

  @override
  set role(Set<int> value) {
    _$roleAtom.reportWrite(value, super.role, () {
      super.role = value;
    });
  }

  late final _$studySubjectsAtom =
      Atom(name: '_RegisterController.studySubjects', context: context);

  @override
  Map<String, dynamic> get studySubjects {
    _$studySubjectsAtom.reportRead();
    return super.studySubjects;
  }

  @override
  set studySubjects(Map<String, dynamic> value) {
    _$studySubjectsAtom.reportWrite(value, super.studySubjects, () {
      super.studySubjects = value;
    });
  }

  late final _$teachSubjectsAtom =
      Atom(name: '_RegisterController.teachSubjects', context: context);

  @override
  Map<String, dynamic> get teachSubjects {
    _$teachSubjectsAtom.reportRead();
    return super.teachSubjects;
  }

  @override
  set teachSubjects(Map<String, dynamic> value) {
    _$teachSubjectsAtom.reportWrite(value, super.teachSubjects, () {
      super.teachSubjects = value;
    });
  }

  @override
  String toString() {
    return '''
username: ${username},
email: ${email},
password: ${password},
phone: ${phone},
gender: ${gender},
birthday: ${birthday},
role: ${role},
studySubjects: ${studySubjects},
teachSubjects: ${teachSubjects}
    ''';
  }
}
