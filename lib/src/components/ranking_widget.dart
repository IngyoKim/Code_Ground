import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';

class RankingWidget extends StatefulWidget {
  final ProgressData rankingData;
  final int rank;

  const RankingWidget({
    super.key,
    required this.rankingData,
    required this.rank,
  });

  @override
  State<RankingWidget> createState() => _RankingWidgetState();
}

class _RankingWidgetState extends State<RankingWidget> {
  String? nickname;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNickname();
  }

  /// 닉네임을 가져오는 함수
  Future<void> _fetchNickname() async {
    final userViewModel = context.read<UserViewModel>();
    await userViewModel.fetchOtherUserData(widget.rankingData.uid);
    final userData = userViewModel.otherUserData;

    if (mounted) {
      setState(() {
        nickname = userData?.nickname;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            '#${widget.rank}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          nickname ?? 'Unknown', // 닉네임 또는 로딩 상태 표시
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          "Score: ${widget.rankingData.score} | Exp: ${widget.rankingData.exp}",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        trailing: Text(
          widget.rankingData.tier,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
