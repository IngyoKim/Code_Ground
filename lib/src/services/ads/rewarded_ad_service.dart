import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService extends ChangeNotifier {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  RewardedAdService() {
    _loadRewardedAd();
  }

  // 리워드 광고 로드
  void _loadRewardedAd() {
    if (_isLoading) return;
    _isLoading = true;

    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // 테스트 광고 ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isLoading = false;
          notifyListeners();
          debugPrint('[RewardedAdService] RewardedAd loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoading = false;
          notifyListeners();
          debugPrint('[RewardedAdService] RewardedAd failed to load: $error');
        },
      ),
    );
  }

  // 리워드 광고 표시
  void showRewardedAd({required Function onRewardEarned}) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          // 사용자가 광고 시청을 완료하면 실행할 로직
          onRewardEarned();
        },
      );
      _rewardedAd = null;
      _loadRewardedAd(); // 광고를 다시 로드
      notifyListeners(); // 상태 변경 알림
    } else {
      debugPrint('[RewardedAdService] Ad is not ready yet');
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  bool get isAdReady => _rewardedAd != null;
}
