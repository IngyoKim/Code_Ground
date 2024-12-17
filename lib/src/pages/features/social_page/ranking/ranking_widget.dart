import 'package:code_ground/src/utils/gettierimage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/models/progress_data.dart';
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
  static final Map<String, String?> _nicknameCache = {};
  String? nickname;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNickname();
  }

  Future<void> _fetchNickname() async {
    if (_nicknameCache.containsKey(widget.rankingData.uid)) {
      setState(() {
        nickname = _nicknameCache[widget.rankingData.uid];
        isLoading = false;
      });
      return;
    }

    final userViewModel = context.read<UserViewModel>();
    await userViewModel.fetchOtherUserData(widget.rankingData.uid);
    final userData = userViewModel.otherUserData;

    if (mounted) {
      setState(() {
        nickname = userData?.nickname;
        _nicknameCache[widget.rankingData.uid] = nickname;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 등수
          SizedBox(
            width: 40,
            child: CircleAvatar(
              backgroundColor: _getRankColor(widget.rank),
              child: Text(
                '#${widget.rank}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          /// 티어 이미지
          Image.asset(
            getTierImage(widget.rankingData.tier),
            width: 48,
            height: 48,
          ),
          const SizedBox(width: 16),

          /// 이름과 경험치, 스코어
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 이름
                Text(
                  nickname ?? 'Loading...',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),

                // 경험치와 스코어 (줄 나눔)
                Text(
                  'Exp: ${widget.rankingData.exp}\nScore: ${widget.rankingData.score}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 등수에 따라 색상을 반환
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // 금색
      case 2:
        return Colors.grey; // 은색
      case 3:
        return Colors.brown; // 동색
      default:
        return const Color.fromARGB(255, 89, 89, 89); // 기본 색상
    }
  }
}
