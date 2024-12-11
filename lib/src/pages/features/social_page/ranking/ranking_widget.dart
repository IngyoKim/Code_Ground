import 'package:code_ground/src/utils/gettierimage.dart';
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
    return CommonListTile(
      leading: Transform.translate(
        offset: const Offset(-8, -2),
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
      title: nickname ?? '',
      subtitle:
          "Score: ${widget.rankingData.score} | Exp: ${widget.rankingData.exp}",
      trailing: Image.asset(
        getTierImage(widget.rankingData.tier),
        width: 40,
        height: 40,
      ),
    );
  }
}
