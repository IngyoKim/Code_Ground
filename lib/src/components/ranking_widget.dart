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
      title: nickname ?? 'Unknown',
      subtitle:
          "Score: ${widget.rankingData.score} | Exp: ${widget.rankingData.exp}",
      trailing: Text(
        widget.rankingData.tier,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
