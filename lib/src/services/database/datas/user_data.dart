import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class UserData {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  String nickname; //여기 이거 고침
  final String role;
  final String friendCode;
  final List<String> friend;

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.nickname,
    required this.role,
    required this.friendCode,
    required this.friend,
  });

  // JSON -> Object
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      uid: json['uid'] ?? '', // 기본값 설정
      name: json['name'] ?? 'Unknown User', // 기본값 설정
      email: json['email'] ?? 'No Email', // 기본값 설정
      photoUrl: json['photoUrl'] ?? '', // 기본값 설정
      nickname: json['nickname'] ?? '', // 기본값 설정
      role: json['role'] ?? '', // 기본값 설정
      friendCode: json['friendCode'] ?? '',
      friend: List<String>.from(json['friend'] ?? []),
    );
  }

  // Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'nickname': nickname,
      'role': role,
      'friendCode': friendCode,
      'friend': friend,
    };
  }
}
