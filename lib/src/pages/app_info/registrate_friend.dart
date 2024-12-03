import 'package:code_ground/src/services/database/database_service.dart';
import 'package:code_ground/src/services/database/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';

class RegistrateFriend extends StatefulWidget {
  const RegistrateFriend({super.key});

  @override
  State<RegistrateFriend> createState() => _RegistrateFriendState();
}

class _RegistrateFriendState extends State<RegistrateFriend> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _friendsList = []; // 닉네임과 friendCode 저장
  final UserManager _userManager = UserManager(); // UserManger 인스턴스 생성

  @override
  void initState() {
    super.initState();
    _fetchFriends(); // 초기 친구 목록 로드
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
          // UID로 닉네임 가져오기
          final userData = await _userManager.readUserData(uid);
          if (userData != null) {
            updatedFriendsList.add({
              'nickname': userData.nickname,
              'friendCode': friendCode,
            });
          } else {
            updatedFriendsList.add({
              'nickname': 'Unknown',
              'friendCode': friendCode,
            });
          }
        } catch (error) {
          debugPrint('Error fetching nickname for $uid: $error');
          updatedFriendsList.add({
            'nickname': 'Error',
            'friendCode': friendCode,
          });
        }
      }
    }

    setState(() {
      _friendsList.clear();
      _friendsList.addAll(updatedFriendsList);
    });

    debugPrint('Updated Friends List: $_friendsList');
  }

  /// 친구 추가 처리
  void _handleSubmit() async {
    final userViewModel = context.read<UserViewModel>();
    final inputText = _controller.text.trim();

    if (inputText.isNotEmpty) {
      try {
        await userViewModel.addFriend(inputText); // 친구 추가 메서드 호출
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend added: $inputText')),
        );
        _controller.clear();
        _fetchFriends(); // 친구 목록 갱신
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid friend code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
    final friends = userViewModel.currentUserData?.friends ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Friend Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Add Friend'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: friends.isEmpty
                  ? const Center(child: Text('No friends added yet.'))
                  : ListView.builder(
                      itemCount: _friendsList.length,
                      itemBuilder: (context, index) {
                        final friend = _friendsList[index];
                        final nickname = friend['nickname'] ?? 'Unknown';
                        final friendCode = friend['friendCode'] ?? 'Unknown';

                        return ListTile(
                          title: Text('$nickname($friendCode)'),
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
