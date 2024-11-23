import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FirebaseAuthData {
  final String url =
      'https://createcustomtoken-rfmajfqpua-uc.a.run.app/createCustomToken';

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final filteredUser =
        user.map((key, value) => MapEntry(key, value?.toString() ?? ''));

    try {
      final customTokenResponse = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(filteredUser),
      );

      if (customTokenResponse.statusCode != 200) {
        throw Exception(
            "Failed to create custom token. Status code: ${customTokenResponse.statusCode}");
      }

      return customTokenResponse.body;
    } catch (error) {
      debugPrint("Error creating custom token: $error");
      rethrow;
    }
  }
}
