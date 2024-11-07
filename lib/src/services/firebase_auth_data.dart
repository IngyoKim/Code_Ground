import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseAuthData {
  final String url =
      'https://createcustomtoken-rfmajfqpua-uc.a.run.app/createCustomToken';

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    // `user` Map에서 `null` 값을 제거하고, 모든 값을 `String` 타입으로 변환
    final filteredUser = user.map((key, value) {
      return MapEntry(key, value?.toString() ?? ''); // null 값은 빈 문자열로 처리
    });

    final customTokenResponse = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(filteredUser),
    );

    return customTokenResponse.body;
  }
}
