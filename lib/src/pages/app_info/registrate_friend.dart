import 'package:flutter/material.dart';
import 'package:code_ground/src/services/database/operations/user_operation.dart';

class RegistrateFriend extends StatefulWidget {
  const RegistrateFriend({super.key});

  @override
  _RegistrateFriendState createState() => _RegistrateFriendState();
}

class _RegistrateFriendState extends State<RegistrateFriend> {
  final TextEditingController _controller = TextEditingController();
  final UserOperation _userOperation = UserOperation(); // UserOperation 인스턴스 추가

  void _handleSubmit() async {
    final inputText = _controller.text;

    if (inputText.isNotEmpty) {
      try {
        await _userOperation.addFriend(inputText); // 친구 추가 호출
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Friend added: $inputText')),
        );
        _controller.clear();
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
          ],
        ),
      ),
    );
  }
}
