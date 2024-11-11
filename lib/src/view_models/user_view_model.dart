import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/operations/user_operation.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';

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

  Future<void> updateUserData(Map<String, dynamic> updates) async {
    await _userOperation.updateUserData(updates);
    await fetchUserData();
  }

  // 사용자 데이터 초기화
  void clearUserData() {
    _userData = null;
    notifyListeners();
  }
}
