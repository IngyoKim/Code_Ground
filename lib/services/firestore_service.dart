import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(int level, int exp, int points) async {
    try {
      await firestore.collection('users').doc('unique_user_id').set({
        'level': level,
        'exp': exp,
        'points': points,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Failed to save user data: $e");
    }
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot doc =
        await firestore.collection('users').doc('unique_user_id').get();
    if (doc.exists) {
      print("User data fetched successfully!");
      return doc.data() as Map<String, dynamic>;
    } else {
      print("No user data found. Using default values.");
      return {'level': 1, 'exp': 0, 'points': 0}; // 기본값
    }
  }
}
