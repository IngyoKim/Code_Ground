import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final String initialNickname;
  final String role;
  final dynamic userData; // userData 객체 추가

  const SettingPage({
    super.key,
    required this.initialNickname,
    required this.role,
    required this.userData,
    required String nickname,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _language = 'English';
  bool _isInfoExpanded = false;
  bool _isEditingNickname = false;

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

  void _updateNickname(String newNickname) {
    setState(() {
      _nickname = newNickname; // 닉네임 상태 업데이트
    });
  }

  void _toggleEditingNickname() {
    setState(() {
      _isEditingNickname = !_isEditingNickname; // 편집 모드 토글
    });
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
            title: const Text('Your INFO'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _isEditingNickname
                      ? TextField(
                          controller: _nicknameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your nickname',
                          ),
                          onSubmitted: (newNickname) {
                            _updateNickname(newNickname);
                            _toggleEditingNickname();
                          },
                        )
                      : Text(
                          'NickName: $_nickname', // 현재 닉네임 표시
                          style: const TextStyle(fontSize: 16.0),
                        ),
                ),
                IconButton(
                  icon: Icon(
                    _isEditingNickname ? Icons.check : Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: _toggleEditingNickname,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Role: ${widget.role}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
          const Divider(),

          // Other Settings Section
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: _darkMode,
              onChanged: (bool value) {
                setState(() {
                  _darkMode = value;
                });
              },
            ),
          ),
          const Divider(),

          ListTile(
            title: const Text('Notifications'),
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
            title: const Text('Language'),
            subtitle: Text(_language),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Korean', child: Text('Korean')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _language = newValue!;
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
