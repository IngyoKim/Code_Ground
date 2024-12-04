import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final String initialNickname;
  final String role;
  final String friendData;
  final dynamic userData; // userData 객체 추가

  const SettingPage({
    super.key,
    required this.initialNickname,
    required this.role,
    required this.userData,
    required String nickname,
    required this.friendData,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _notificationsEnabled = true;
  bool _isInfoExpanded = false;

  late TextEditingController _nicknameController;
  late String _nickname;

  @override
  void initState() {
    super.initState();
    // 닉네임 초기화: userData 기반
    _nickname = widget.userData?.nickname.isNotEmpty == true
        ? widget.userData!.nickname
        : widget.userData?.name ?? 'Guest';
    _nicknameController = TextEditingController(text: _nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Your Info Section
          ListTile(
            title: Text(
              'Your INFO',
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            trailing: Icon(
              _isInfoExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
            onTap: () {
              setState(() {
                _isInfoExpanded = !_isInfoExpanded;
              });
            },
          ),
          if (_isInfoExpanded) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16.0), // 오른쪽으로 당기기
              child: Text(
                'NickName: $_nickname', // 현재 닉네임 표시
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 8.0), // 줄 간격 추가
            Padding(
              padding: const EdgeInsets.only(left: 16.0), // 오른쪽으로 당기기
              child: Text(
                'Role: ${widget.role}', // 역할 정보
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 8.0), // 줄 간격 추가
            Padding(
              padding: const EdgeInsets.only(left: 16.0), // 오른쪽으로 당기기
              child: Text(
                'FriendCode: ${widget.friendData}', // 역할 정보
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
          const Divider(),

          ListTile(
            title: Text(
              'Notifications',
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Insert Friends Code',
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
