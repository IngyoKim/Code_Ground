import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/view_models/user_view_model.dart'; // UserViewModel import
import 'package:code_ground/src/utils/toast_message.dart'; // ToastMessage import

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
  bool _isEditingNickname = false;
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    // userData의 nickname 또는 초기값으로 텍스트 필드 초기화
    _nicknameController = TextEditingController(
        text: widget.userData?.nickname.isNotEmpty == true
            ? widget.userData!.nickname
            : widget.userData?.name ?? 'Guest');
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _updateNickname() async {
    final user =
        Provider.of<UserViewModel>(context, listen: false).currentUserData;

    if (user == null) {
      ToastMessage.show('Please log in to continue.');
      return;
    }

    final newNickname = _nicknameController.text.trim();

    if (newNickname.isEmpty || newNickname == widget.userData?.nickname) {
      ToastMessage.show('No changes made.');
      return;
    }

    try {
      // 사용자 정보 업데이트: UserViewModel을 사용하여 nickname 저장
      await Provider.of<UserViewModel>(context, listen: false)
          .updateNickname(newNickname);

      if (mounted) {
        ToastMessage.show('Nickname updated successfully.');

        // setState를 사용하여 UI 업데이트
        setState(() {
          // 여기에서 nickname을 변경
          widget.userData.nickname = newNickname; // userData의 nickname을 업데이트
        });

        Navigator.pop(context); // 닉네임을 업데이트 후 페이지 닫기
      }
    } catch (error) {
      ToastMessage.show('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Edit Nickname'),
            trailing: Icon(
              _isEditingNickname ? Icons.check : Icons.edit,
              color: Colors.blue,
            ),
            onTap: () {
              setState(() {
                _isEditingNickname = !_isEditingNickname;
              });
            },
          ),
          if (_isEditingNickname) ...[
            // 닉네임을 수정할 수 있는 TextField
            TextField(
              controller: _nicknameController,
              decoration:
                  const InputDecoration(hintText: 'Enter your nickname'),
            ),
            ElevatedButton(
              onPressed: _updateNickname,
              child: const Text('Save Nickname'),
            ),
          ] else ...[
            // 닉네임을 보여주는 부분
            Text(
              'Nickname: ${_nicknameController.text}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
