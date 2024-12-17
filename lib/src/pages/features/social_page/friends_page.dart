import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/services/database/user_manager.dart';
import 'package:code_ground/src/pages/features/profile_page/user_detail_page.dart';

class RegistrateFriends extends StatefulWidget {
  const RegistrateFriends({super.key});

  @override
  State<RegistrateFriends> createState() => _RegistrateFriendsState();
}

class _RegistrateFriendsState extends State<RegistrateFriends> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _friendsList = [];
  final UserManager _userManager = UserManager();
  String _myFriendCode = '';

  @override
  void initState() {
    super.initState();
    _fetchFriends();
    _fetchMyFriendCode();
  }

  /// 내 친구 코드 가져오기
  void _fetchMyFriendCode() async {
    final userViewModel = context.read<UserViewModel>();
    await userViewModel.fetchCurrentUserData();
    setState(() {
      _myFriendCode = userViewModel.currentUserData?.friendCode ?? 'Unknown';
    });
  }

  /// 친구 목록 가져오기
  void _fetchFriends() async {
    final userViewModel = context.read<UserViewModel>();
    await userViewModel.fetchCurrentUserData();
    final friends = userViewModel.currentUserData?.friends ?? [];

    List<Map<String, String>> updatedFriendsList = [];

    for (final friend in friends) {
      final uid = friend['uid'];
      final friendCode = friend['friendCode'];

      if (uid != null && friendCode != null) {
        try {
          final userData = await _userManager.readUserData(uid);
          if (userData != null) {
            updatedFriendsList.add({
              'nickname': userData.nickname,
              'friendCode': friendCode,
              'uid': uid, // 친구의 UID 추가
            });
          } else {
            updatedFriendsList.add({
              'nickname': 'Unknown',
              'friendCode': friendCode,
              'uid': uid,
            });
          }
        } catch (error) {
          debugPrint('Error fetching nickname for $uid: $error');
          updatedFriendsList.add({
            'nickname': 'Error',
            'friendCode': friendCode,
            'uid': uid,
          });
        }
      }
    }

    setState(() {
      _friendsList.clear();
      _friendsList.addAll(updatedFriendsList);
    });
  }

  /// 친구 추가 처리
  void _handleSubmit() async {
    final userViewModel = context.read<UserViewModel>();
    final inputText = _controller.text.trim();

    if (inputText.isNotEmpty) {
      try {
        await userViewModel.addFriend(inputText);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('친구가 추가 되었습니다.: $inputText')),
        );
        _controller.clear();
        _fetchFriends();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효한 친구코드를 넣어주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
    final friends = userViewModel.currentUserData?.friends ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('친구 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 내 친구 코드 표시
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '나의 친구 코드: $_myFriendCode',
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: '친구 코드 입력',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
              ),
              child: const Text(
                '친구 추가',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: friends.isEmpty
                  ? const Center(child: Text('아직 친구가 없습니다.'))
                  : ListView.builder(
                      itemCount: _friendsList.length,
                      itemBuilder: (context, index) {
                        final friend = _friendsList[index];
                        final nickname = friend['nickname'] ?? 'Unknown';
                        final uid = friend['uid'] ?? '';

                        return ListTile(
                          title: Text('$nickname'),
                          onTap: () {
                            UserDetailPage.show(context, uid);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
