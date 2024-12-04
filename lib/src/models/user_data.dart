class UserData {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  String nickname;
  final String role;
  final String friendCode;
  final List<Map<String, String>> friends;

  UserData({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.nickname,
    required this.role,
    required this.friendCode,
    required this.friends,
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
      friends: List<Map<String, String>>.from(json['friends']?.map((friend) {
            return Map<String, String>.from(friend);
          }) ??
          []),
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
      'friends':
          friends.map((friend) => Map<String, String>.from(friend)).toList(),
    };
  }
}
