class UserData {
  final String userId;
  final String name;
  final String email;
  final String photoUrl;
  final String nickname;
  final bool isAdmin;

  UserData({
    required this.userId,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.nickname,
    required this.isAdmin,
  });

  // JSON -> Object
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'] ?? '', // 기본값 설정
      name: json['name'] ?? 'Unknown User', // 기본값 설정
      email: json['email'] ?? 'No Email', // 기본값 설정
      photoUrl: json['photoUrl'] ?? '', // 기본값 설정
      nickname: json['nickname'] ?? '', // 기본값 설정
      isAdmin: json['isAdmin'] ?? false, // 기본값 설정
    );
  }

  // Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'nickname': nickname,
      'isAdmin': isAdmin,
    };
  }
}
