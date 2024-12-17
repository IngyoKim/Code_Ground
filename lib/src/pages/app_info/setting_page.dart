import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final String initialNickname; /// Initial nickname
  final String role; /// User's role
  final String friendData; /// Friend data
  final dynamic userData; /// User data object

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
  bool _isInfoExpanded = false; /// Whether the info section is expanded

  late TextEditingController _nicknameController; /// Controller for nickname input
  late String _nickname; /// Current nickname

  @override
  void initState() {
    super.initState();
    /// Initialize nickname based on userData
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
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          /// Your Info Section
          ListTile(
            title: Text(
              'Your Info',
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
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Nickname: $_nickname',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Role: ${widget.role}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Friend Code: ${widget.friendData}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
          const Divider(),
        ],
      ),
    );
  }
}

