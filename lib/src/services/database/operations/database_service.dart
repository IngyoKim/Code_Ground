import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  FirebaseDatabase database = FirebaseDatabase.instance;

  /// Generic write method for any data type
  Future<void> writeDB(String path, Map<String, dynamic> data) async {
    DatabaseReference ref = database.ref(path);
    try {
      await ref.set(data);
      debugPrint("[DatabaseService] Data written to $path: $data");
    } catch (error) {
      debugPrint("[DatabaseService] Error writing data to $path: $error");
      rethrow;
    }
  }

  /// Generic read method for any data type
  Future<Map<dynamic, dynamic>?> readDB(String path) async {
    DatabaseReference ref = database.ref(path);
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        debugPrint("[DatabaseService] Data read from $path: ${snapshot.value}");
        return snapshot.value as Map<dynamic, dynamic>;
      } else {
        debugPrint("[DatabaseService] No data available at path: $path");
        return null;
      }
    } catch (error) {
      debugPrint("[DatabaseService] Error reading data from $path: $error");
      rethrow;
    }
  }

  /// Generic update method for any data type
  Future<void> updateDB(String path, Map<String, dynamic> updates) async {
    DatabaseReference ref = database.ref(path);
    try {
      await ref.update(updates);
      debugPrint("[DatabaseService] Data updated at $path: $updates");
    } catch (error) {
      debugPrint("[DatabaseService] Error updating data at $path: $error");
      rethrow;
    }
  }

  /// Fetch method for retrieving filtered and sorted data
  Future<List<Map<String, dynamic>>> fetchDB(
    String path, {
    String? orderByChild,
    dynamic startAt,
    dynamic endAt,
    int? limitToFirst,
    int? limitToLast,
  }) async {
    DatabaseReference ref = database.ref(path);
    Query query = ref;

    // Apply query parameters
    if (orderByChild != null) query = query.orderByChild(orderByChild);
    if (startAt != null) query = query.startAt(startAt);
    if (endAt != null) query = query.endAt(endAt);
    if (limitToFirst != null) query = query.limitToFirst(limitToFirst);
    if (limitToLast != null) query = query.limitToLast(limitToLast);

    try {
      final snapshot = await query.get();
      if (snapshot.exists) {
        final data = snapshot.children
            .map((child) => Map<String, dynamic>.from(child.value as Map))
            .toList();
        debugPrint(
            "[DatabaseService] Data fetched from $path with query: $data");
        return data;
      } else {
        debugPrint("[DatabaseService] No data available with query at $path");
        return [];
      }
    } catch (error) {
      debugPrint("[DatabaseService] Error fetching data from $path: $error");
      rethrow;
    }
  }
}
