import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoShareManager {
  /// Method to dynamically create a FeedTemplate
  FeedTemplate createFeedTemplate(String nickname) {
    return FeedTemplate(
      content: Content(
        title: 'Code Ground',

        /// Dynamically inserts the nickname
        description: '코딩 공부의 일상화\n$nickname님이 초대했어요!',
        imageUrl: Uri.parse(
            'https://raw.githubusercontent.com/IngyoKim/Code_Ground/refs/heads/main/assets/logo/code_ground_logo.png'),
        link: Link(
          webUrl: Uri.parse('https://developers.kakao.com'),
          mobileWebUrl: Uri.parse('https://developers.kakao.com'),
        ),
      ),
      buttons: [
        Button(
          title: '지금 시작하기',
          link: Link(
            webUrl: Uri.parse('https://www.naver.com/'),
            mobileWebUrl: Uri.parse('https://www.naver.com/'),
          ),
        ),
      ],
    );
  }

  Future<void> shareContent(String nickname) async {
    FeedTemplate dynamicFeedTemplate = createFeedTemplate(nickname);

    /// Check if KakaoTalk is available to share
    bool isKakaoTalkSharingAvailable =
        await ShareClient.instance.isKakaoTalkSharingAvailable();

    if (isKakaoTalkSharingAvailable) {
      try {
        Uri uri = await ShareClient.instance
            .shareDefault(template: dynamicFeedTemplate);
        await ShareClient.instance.launchKakaoTalk(uri);
        print('카카오톡 공유 완료');
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    } else {
      try {
        Uri shareUrl = await WebSharerClient.instance
            .makeDefaultUrl(template: dynamicFeedTemplate);
        await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {
        print('카카오톡 공유 실패 $error');
      }
    }
  }
}

Future<String> createCustomLink(String friendUid) async {
  /// Base URL template for the Branch link
  const String branchBaseUrl = "https://code_ground.app.link";

  /// Generate a custom URL with the friend's UID
  String customUrl = "$branchBaseUrl?uid=$friendUid";
  print("Generated Custom Branch Link: $customUrl");

  return customUrl;
}
