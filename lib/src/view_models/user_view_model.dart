import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';
import 'package:code_ground/src/services/database/operations/user_operation.dart';

class UserViewModel extends ChangeNotifier {
  final UserOperation _userOperation = UserOperation();
  UserData? _userData;

  UserData? get userData => _userData;

  Future<void> fetchUserData() async {
    _userData = await _userOperation.readUserData();

    // 데이터가 없을 경우 초기 데이터를 쓰는 로직 추가
    if (_userData == null) {
      await _userOperation.writeUserData();
      _userData = await _userOperation.readUserData();
    }

    notifyListeners();
  }

  Future<void> updateNickname(String data) async {
    if (_userData == null) fetchUserData();
    await _userOperation.updateUserData({'nickname': data});
    await fetchUserData();
  }

  Future<void> grantAdmin(bool data) async {
    if (_userData == null) fetchUserData();
    await _userOperation.updateUserData({'isAdmin': data});
    await fetchUserData();
  }
}
