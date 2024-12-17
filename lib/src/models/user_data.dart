class UserData {
  final String uid; /// User ID
  final String name; /// User's full name
  final String email; /// User's email address
  final String photoUrl; /// URL of the user's profile photo
  String nickname; /// User's nickname
  final String role; /// User's role (e.g., admin, member)
  final String friendCode; /// Unique friend code for the user
  final List<Map<String, String>> friends; /// List of friends (as maps of key-value pairs)

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

  /// Convert JSON to UserData object
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      uid: json['uid'] ?? '', /// Default value
      name: json['name'] ?? 'Unknown User', /// Default value
      email: json['email'] ?? 'No Email', /// Default value
      photoUrl: json['photoUrl'] ?? '', /// Default value
      nickname: json['nickname'] ?? '', /// Default value
      role: json['role'] ?? '', /// Default value
      friendCode: json['friendCode'] ?? '',
      friends: List<Map<String, String>>.from(json['friends']?.map((friend) {
            return Map<String, String>.from(friend);
          }) ??
          []),
    );
  }

  /// Convert UserData object to JSON
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

