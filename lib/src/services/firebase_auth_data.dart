import 'package:http/http.dart' as http;

class FirebaseAuthData {
  final String url = 'https://createcustomtoken-rfmajfqpua-uc.a.run.app/';

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final customTokenResponse = await http.post(Uri.parse(url), body: user);

    return customTokenResponse.body;
  }
}
