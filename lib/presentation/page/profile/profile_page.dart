import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/login/login_page.dart';
import 'package:propercloure/presentation/page/management/management_page.dart';
import 'package:propercloure/presentation/page/scren_theme/screntheme_page.dart';
import 'package:propercloure/presentation/page/home/home_page.dart';
import 'package:propercloure/presentation/page/profile/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ProfileViewModel();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeLabel = isDarkMode ? "다크 모드" : "라이트 모드";
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Text("설정"),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 로고와 앱 이름
            FutureBuilder<Map<String, dynamic>?>(
              future: viewModel.fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: const AssetImage(
                          "assets/image/logo.png",
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "바른 맞음",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "이메일 정보 없음",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Text(
                        "바른 맺음 1.0.0",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  );
                }
                final data = snapshot.data ?? {};
                final photoUrl = data['photoUrl'] as String?;
                final name = data['name'] as String? ?? "바른 맞음";
                final email = data['email'] as String? ?? "이메일 정보 없음";
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : const AssetImage("assets/image/logo.png")
                                as ImageProvider,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Text(
                      "바른 맺음 1.0.0",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            // 설정 섹션
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "설정",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // 화면 테마
                  ListTile(
                    title: const Text("화면 테마"),
                    trailing: Text(
                      "$themeLabel >",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => const ScrenThemePage(),
                        ),
                      );
                    },
                  ),

                  // 프로필 관리
                  FutureBuilder<Map<String, dynamic>?>(
                    future: viewModel.fetchUserData(),
                    builder: (context, snapshot) {
                      String displayName = "닉네임 없음";
                      if (snapshot.hasData && snapshot.data != null) {
                        final data = snapshot.data ?? {};
                        displayName = data['name'] as String? ?? "닉네임 없음";
                      }
                      return ListTile(
                        title: const Text("프로필 관리"),
                        trailing: Text("$displayName >"),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManagementPage(),
                            ),
                          );
                          if (result == true) {
                            setState(() {});
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 50),

                  // 버튼 영역
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode
                                ? Colors.grey[800]
                                : Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await viewModel.logout();

                              if (!context.mounted) return;

                              // 로그인 페이지로 이동
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            } catch (e) {
                              debugPrint('Logout error: $e');
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('로그아웃 중 오류가 발생했습니다.'),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "로그인 아웃",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('회원 탈퇴'),
                                  content: const Text('정말로 회원 탈퇴를 진행하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('확인'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirm == true) {
                              try {
                                await viewModel.deleteAccount();

                                if (!context.mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              } catch (e) {
                                debugPrint('Delete account error: $e');
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('회원 탈퇴 중 오류가 발생했습니다.'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "회원 탈퇴",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
