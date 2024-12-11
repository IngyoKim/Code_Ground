import 'package:flutter/material.dart';

Future<String> createCustomLink(String friendUid) async {
  /// Base URL template for the Branch link
  const String branchBaseUrl = "https://code_ground.app.link";

  /// Generate a custom URL with the friend's UID
  String customUrl = "$branchBaseUrl?uid=$friendUid";
  debugPrint("Generated Custom Branch Link: $customUrl");

  return customUrl;
}
