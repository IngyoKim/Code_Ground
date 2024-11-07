import 'package:http/http.dart' as http;

class FirebaseAuthData {
  final String url =
      'https://createcustomtoken-rfmajfqpua-uc.a.run.app/createCustomToken';

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    // `user` Map에서 `null` 값을 필터링하고 모든 값을 `String` 타입으로 변환
    final filteredUser = user.map((key, value) {
      if (value == null) return MapEntry(key, ''); // null 값은 빈 문자열로 처리
      return MapEntry(key, value.toString()); // 모든 값을 String 타입으로 변환
    });

    final customTokenResponse = await http.post(
      Uri.parse(url),
      body: filteredUser,
    );

    return customTokenResponse.body;
  }
}
