import 'package:firebase_auth/firebase_auth.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';
import 'package:code_ground/src/services/database/database_service.dart';

class UserOperations {
  final DatabaseService _databaseService = DatabaseService();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> writeUserData() async {
    if (user == null) return;
    String path = 'users/${user!.uid}';
    await _databaseService.writeDB(path, {
      'name': user?.displayName ?? '',
      'email': user?.email ?? '',
      'profileImageUrl': user?.photoURL ?? '',
    });
  }

  Future<UserData?> readUserData() async {
    if (user == null) return null;
    String path = 'users/${user!.uid}';
    final data = await _databaseService.readDB(path);
    if (data != null) {
      return UserData(
        userId: user!.uid,
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        profileImageUrl: data['profileImageUrl'] ?? '',
      );
    }
    return null;
  }

  Future<void> updateUserData(Map<String, dynamic> updates) async {
    if (user == null) return;
    String path = 'users/${user!.uid}';
    await _databaseService.updateDB(path, updates);
  }
}
