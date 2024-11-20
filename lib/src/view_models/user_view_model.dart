import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';
import 'package:code_ground/src/services/database/operations/user_operation.dart';

class UserViewModel extends ChangeNotifier {
  final UserOperation _userOperation = UserOperation();
  UserData? _userData;

  UserData? get userData => _userData;

  Future<UserData?> fetchUserData({String? uid}) async {
    _userData = await _userOperation.readUserData(uid: uid);

    /// Adds logic to write initial data if no data exists.
    if (_userData == null) {
      await _userOperation.writeUserData();
      _userData = await _userOperation.readUserData();
    }

    notifyListeners();
    return _userData;
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
