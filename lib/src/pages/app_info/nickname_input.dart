import 'package:flutter/material.dart';

class NicknameInput extends StatelessWidget {
  final TextEditingController nicknameController;

  const NicknameInput({
    super.key,
    required this.nicknameController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: nicknameController,
        decoration: const InputDecoration(
          labelText: 'Nickname', // 레이블 텍스트를 "Nickname"으로 설정
          hintText: 'Enter your nickname', // 힌트 텍스트 추가
        ),
        maxLines: 1, // 한 줄만 입력 가능하도록 제한
        keyboardType: TextInputType.text, // 일반 텍스트 키보드
      ),
    );
  }
}
