class UserData {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  String nickname; //여기 이거 고침
  final String role;

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.nickname,
    required this.role,
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
    };
  }
}
