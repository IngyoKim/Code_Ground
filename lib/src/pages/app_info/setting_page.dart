import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final String initialNickname;
  final String role;

  const SettingPage({
    super.key,
    required this.initialNickname,
    required this.role,
    required nickname,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _language = 'English';
  bool _isInfoExpanded = false;
  bool _isEditingNickname = false; // 닉네임 편집 상태

  late TextEditingController _nicknameController;
  late String _nickname; // 닉네임을 상태로 관리
//hint input의 예시를 보고 고치기
  @override
  void initState() {
    super.initState();
    _nickname = widget.initialNickname; // 초기값 설정
    _nicknameController = TextEditingController(text: _nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _updateNickname(String newNickname) {
    setState(() {
      _nickname = newNickname; // 수정된 nickname을 상태에 저장
      _nicknameController.text = newNickname; // TextField에 반영
    });
  }

  void _toggleEditingNickname() {
    setState(() {
      _isEditingNickname = !_isEditingNickname;
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
                _isEditingNickname
                    ? Expanded(
                        child: TextField(
                          controller: _nicknameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your nickname',
                          ),
                          onSubmitted: _updateNickname, // 수정된 닉네임 저장
                        ),
                      )
                    : Text(
                        'NickName: $_nickname', // 수정된 nickname 사용
                        style: const TextStyle(fontSize: 16.0),
                      ),
                IconButton(
                  icon: Icon(
                    _isEditingNickname ? Icons.check : Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: _toggleEditingNickname, // 편집 모드 전환
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Role: ${widget.role}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
          const Divider(), //확인하고 고치기

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
