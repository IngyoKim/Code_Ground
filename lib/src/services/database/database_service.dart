import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  FirebaseDatabase database = FirebaseDatabase.instance;

  // Generic write method for any data type
  Future<void> writeDB(String path, Map<String, dynamic> data) async {
    DatabaseReference ref = database.ref(path);
    await ref.set(data);
  }

  // Generic read method for any data type
  Future<Map<dynamic, dynamic>?> readDB(String path) async {
    DatabaseReference ref = database.ref(path);
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return snapshot.value as Map<dynamic, dynamic>;
    } else {
      debugPrint("No data available at path: $path");
      return null;
    }
  }

  // Generic update method for any data type
  Future<void> updateDB(String path, Map<String, dynamic> updates) async {
    DatabaseReference ref = database.ref(path);
    await ref.update(updates);
  }
}
