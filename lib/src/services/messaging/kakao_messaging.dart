import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:code_ground/src/services/messaging/custom_url.dart';

class KakaoMessaging {
  /// Method to dynamically create a FeedTemplate
  FeedTemplate createFeedTemplate(String nickname, String customUrl) {
    return FeedTemplate(
      content: Content(
        title: 'Code Ground',
        description: '코딩 공부의 일상화\n$nickname님이 초대했어요!',
        imageUrl: Uri.parse(
            'https://raw.githubusercontent.com/IngyoKim/Code_Ground/refs/heads/main/assets/logo/code_ground_logo.png'),
        link: Link(
          webUrl: Uri.parse(customUrl), // Use the custom URL here
          mobileWebUrl: Uri.parse(customUrl),
        ),
      ),
      buttons: [
        Button(
          title: '지금 시작하기',
          link: Link(
            webUrl: Uri.parse(customUrl),
            mobileWebUrl: Uri.parse(customUrl),
          ),
        ),
      ],
    );
  }

  /// Method to share content using a dynamically generated custom URL
  Future<void> shareContent(String nickname, String friendUid) async {
    /// Generate a custom link for the friend
    String customUrl = await createCustomLink(friendUid);

    /// Create the dynamic FeedTemplate with the custom URL
    FeedTemplate dynamicFeedTemplate = createFeedTemplate(nickname, customUrl);

    /// Check if KakaoTalk is available to share
    bool isKakaoTalkSharingAvailable =
        await ShareClient.instance.isKakaoTalkSharingAvailable();

    if (isKakaoTalkSharingAvailable) {
      try {
        Uri uri = await ShareClient.instance
            .shareDefault(template: dynamicFeedTemplate);
        await ShareClient.instance.launchKakaoTalk(uri);
        debugPrint('카카오톡 공유 완료');
      } catch (error) {
        debugPrint('카카오톡 공유 실패 $error');
      }
    } else {
      try {
        Uri shareUrl = await WebSharerClient.instance
            .makeDefaultUrl(template: dynamicFeedTemplate);
        await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {
        debugPrint('카카오톡 공유 실패 $error');
      }
    }
  }
}
