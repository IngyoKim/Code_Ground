import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/operations/user_operation.dart';
import 'package:code_ground/src/services/database/datas/user_data.dart';

class RegistrateFriend extends StatefulWidget {
  const RegistrateFriend({super.key});

  @override
  _RegistrateFriendState createState() => _RegistrateFriendState();
}

class _RegistrateFriendState extends State<RegistrateFriend> {
  final TextEditingController _controller = TextEditingController();
  final UserOperation _userOperation = UserOperation(); // UserOperation 인스턴스 추가
  List<String> _friendCodes = []; // 친구 코드 리스트

  @override
  void initState() {
    super.initState();
    _fetchFriends(); // 친구 목록 가져오기
  }

  void _fetchFriends() async {
    try {
      final userData = await _userOperation.readUserData(); // 현재 유저 데이터 가져오기
      if (userData != null) {
        setState(() {
          _friendCodes = userData.friend; // 친구 리스트 업데이트
        });
      }
    } catch (error) {
      debugPrint('Error fetching friends: $error');
    }
  }

  void _handleSubmit() async {
    final inputText = _controller.text;

    if (inputText.isNotEmpty) {
      try {
        await _userOperation.addFriend(inputText); // 친구 추가 호출
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend added: $inputText')),
        );
        _controller.clear();
        _fetchFriends(); // 새 친구 목록 갱신
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid friend code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Friend Code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text('Add Friend'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _friendCodes.isEmpty
                  ? Center(child: Text('No friends added yet.'))
                  : ListView.builder(
                      itemCount: _friendCodes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_friendCodes[index]),
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
