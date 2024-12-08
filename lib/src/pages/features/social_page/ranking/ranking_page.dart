import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/pages/features/social_page/ranking/ranking_utils.dart';
import 'package:code_ground/src/pages/features/social_page/ranking/ranking_widget.dart';
import 'package:code_ground/src/components/loading_indicator.dart';

import 'package:code_ground/src/models/progress_data.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final RankingUtils<ProgressData> _rankingListUtil = RankingUtils();
  final ScrollController _scrollController = ScrollController();
  bool _isInitialLoading = true;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _initializePage();
    _scrollController.addListener(_onScroll);
  }

  /// 초기 데이터 로딩
  Future<void> _initializePage() async {
    final progressViewModel =
        Provider.of<ProgressViewModel>(context, listen: false);

    setState(() {
      _isInitialLoading = true;
    });

    _rankingListUtil.reset();

    await progressViewModel.fetchRankings(orderBy: 'score');
    _rankingListUtil.addItems(progressViewModel.rankings);

    if (mounted) {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  /// 스크롤 이벤트 핸들러
  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore) {
      await _fetchMoreData();
    }
  }

  /// 추가 데이터 로드
  Future<void> _fetchMoreData() async {
    final progressViewModel =
        Provider.of<ProgressViewModel>(context, listen: false);

    if (progressViewModel.isFetchingRankings) return;

    setState(() {
      _isFetchingMore = true;
    });

    await progressViewModel.fetchRankings(orderBy: 'score');
    _rankingListUtil.addItems(progressViewModel.rankings);

    if (mounted) {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rankings = _rankingListUtil.items;

    return Scaffold(
      appBar: AppBar(title: const Text("Ranking System")),
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: rankings.length + 1,
              itemBuilder: (context, index) {
                if (index == rankings.length) {
                  return LoadingIndicator(isFetching: _isFetchingMore);
                }

                final ranking = rankings[index];
                return RankingWidget(
                  rankingData: ranking,
                  rank: index + 1,
                );
              },
            ),
    );
  }
}
