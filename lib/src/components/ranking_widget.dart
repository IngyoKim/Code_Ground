import 'package:code_ground/src/pages/app_info/gettierimage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/models/progress_data.dart';
import 'package:code_ground/src/components/common_list_tile.dart';
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
    return CommonListTile(
      leading: Transform.translate(
        offset: const Offset(-8, -2), // 왼쪽으로 10px, 위로 5px 이동
        child: CircleAvatar(
          backgroundColor: Colors.orange.shade300,
          child: Text(
            '#${widget.rank}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: nickname ?? 'Unknown',
      subtitle:
          "Score: ${widget.rankingData.score} | Exp: ${widget.rankingData.exp}",
      trailing: Image.asset(
        getTierImage(widget.rankingData.tier), // 티어에 맞는 이미지를 가져옴
        width: 40, // 이미지 크기 조정 (필요시)
        height: 40, // 이미지 크기 조정 (필요시)
        //fit: BoxFit.cover, // 이미지 비율 맞추기
      ),
    );
  }
}
