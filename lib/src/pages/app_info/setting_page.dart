import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final String initialNickname;
  final bool isAdmin;

  const SettingPage({
    Key? key,
    required this.initialNickname,
    required this.isAdmin,
    required String nickname,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.initialNickname);
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
                          onSubmitted: (newNickname) {
                            setState(() {
                              // nickname 수정->그런데 저장이 안 되는 문제가 발생. 데이터베이스 구조를 바꿔서 문제인건지는 모르겠음.
                            });
                          },
                        ),
                      )
                    : Text(
                        'NickName: ${_nicknameController.text}', // 수정된 nickname 사용
                        style: const TextStyle(fontSize: 16.0),
                      ),
                IconButton(
                  icon: Icon(
                    _isEditingNickname ? Icons.check : Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditingNickname = !_isEditingNickname;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Admin: ${widget.isAdmin ? 'Yes' : 'No'}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
          const Divider(),

          // 나머지 설정 항목들
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
