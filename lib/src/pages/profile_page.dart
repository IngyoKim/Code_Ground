import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:code_ground/src/view_models/login_view_model.dart';
import 'package:code_ground/src/view_models/user_view_model.dart';
import 'package:code_ground/src/view_models/progress_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // ProfilePage가 열릴 때 필요한 데이터들을 가져오는 부분
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final progressViewModel =
          Provider.of<ProgressViewModel>(context, listen: false);

      userViewModel.fetchUserData();
      progressViewModel.fetchProgressData(
          userViewModel.userData?.userId ?? '', 'questionId'); // 예시 questionId
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(context.toString());

    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context);
    final progressViewModel = Provider.of<ProgressViewModel>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              leading: ClipOval(
                child: loginViewModel.user?.photoURL != null
                    ? Image.network(
                        loginViewModel.user!.photoURL!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 50,
                      ),
              ),
              title: Text(userViewModel.userData?.name ?? ''),
              subtitle: userViewModel.userData?.email != null &&
                      userViewModel.userData?.email != ''
                  ? Text(userViewModel.userData!.email)
                  : null,
              trailing: ElevatedButton(
                onPressed: () async {
                  await loginViewModel.logout();
                },
                child: const Text("로그아웃"),
              ),
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                const Text(
                  "EXP",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: LinearProgressIndicator(
                    value: (progressViewModel.progressData?.experience ?? 0) /
                        (progressViewModel.progressData?.expToNextLevel ?? 1),
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 8.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  "${((progressViewModel.progressData?.experience ?? 0) / (progressViewModel.progressData?.expToNextLevel ?? 1) * 100).toInt()}%",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "Tier: ${progressViewModel.progressData?.level ?? 'Loading...'}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
