import 'dart:async'; // Timer를 사용하기 위한 import
import 'package:code_ground/src/services/database/datas/progress_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref(); // Firebase 참조
  List<ProgressData> _rankings = []; // 랭킹 데이터를 저장할 리스트
  late Timer _timer; // Timer를 사용하여 10분마다 업데이트

  @override
  void initState() {
    super.initState();
    _loadRankings(); // 초기 로딩
    // 10분마다 _loadRankings()를 호출하는 타이머 설정
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      _loadRankings();
    });
  }

  /// Firebase에서 랭킹 데이터 로드
  Future<void> _loadRankings() async {
    final DataSnapshot snapshot = await _databaseRef
        .child("Progress") // progress 노드에서 데이터 가져오기
        .orderByChild("score") // score 기준으로 정렬
        .limitToLast(10) // 상위 10명 가져오기
        .get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      List<ProgressData> rankings = [];

      data.forEach((key, value) {
        final progress =
            ProgressData.fromJson(Map<String, dynamic>.from(value));
        rankings.add(progress);
      });

      // Firebase는 기본적으로 오름차순 정렬이므로, 내림차순으로 변환
      rankings.sort((a, b) => b.score.compareTo(a.score));

      setState(() {
        _rankings = rankings;
      });
    } else {
      print("NO DATA AVAILABLE FOR RANKINGS");
    }
  }

  @override
  void dispose() {
    // 화면이 닫힐 때 타이머를 취소
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ranking System")),
      body: _rankings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _rankings.length,
              itemBuilder: (context, index) {
                final ranking = _rankings[index];
                return ListTile(
                  leading: Text("#${index + 1}"),
                  title: Text(ranking.uid),
                  subtitle: Text("Score: ${ranking.score}"),
                  trailing: Text(
                    ranking.tier,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
