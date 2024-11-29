import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:code_ground/src/components/loading_indicator.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePage();
    _scrollController.addListener(_onScroll);
  }

  /// 초기 데이터 로드
  Future<void> _initializePage() async {
    final progressViewModel =
        Provider.of<ProgressViewModel>(context, listen: false);

    setState(() {
      _isInitialLoading = true;
    });

    await progressViewModel.fetchRankings(
        orderBy: 'score'); // score에 따른 랭킹 불러오기

    if (mounted) {
      setState(() {
        _isInitialLoading = false;
      });
    }
    print("Rankings Loaded>>>>>>>> ${progressViewModel.rankings}");
  }

  /// 스크롤 이벤트 핸들러
  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore) {
      await _fetchMoreRankings();
    }
  }

  /// 추가 랭킹 데이터를 로드
  Future<void> _fetchMoreRankings() async {
    final progressViewModel =
        Provider.of<ProgressViewModel>(context, listen: false);

    if (progressViewModel.isFetchingRankings) return;

    setState(() {
      _isFetchingMore = true;
    });

    final lastScore = progressViewModel.rankings.isNotEmpty
        ? progressViewModel.rankings.last.score
        : null;

    await progressViewModel.fetchRankings(
      orderBy: 'score',
      lastValue: lastScore,
    );

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
    final progressViewModel = Provider.of<ProgressViewModel>(context);
    final rankings = progressViewModel.rankings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Rankings'),
      ),
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : rankings.isEmpty
              ? const Center(child: Text('No rankings available.'))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: rankings.length + 1,
                  itemBuilder: (context, index) {
                    if (index == rankings.length) {
                      return _isFetchingMore
                          ? const LoadingIndicator(isFetching: true)
                          : const SizedBox.shrink();
                    }

                    final ranking = rankings[index];
                    return ListTile(
                      leading: Text(
                        '#${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        ranking.uid ?? 'Unknown User',
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text('Score: ${ranking.score}'),
                      trailing: ranking.tier != null
                          ? Text(
                              ranking.tier!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            )
                          : null,
                    );
                  },
                ),
    );
  }
}
