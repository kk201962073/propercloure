import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/login/login_page.dart';
import 'package:propercloure/presentation/page/management/management_page.dart';
import 'package:propercloure/presentation/page/scren_theme/screntheme_page.dart';
import 'package:propercloure/presentation/page/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
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
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
              future: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  return null;
                }
                return FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();
              }(),
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
                if (!snapshot.data!.exists) {
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
                final data = snapshot.data!.data() ?? {};
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
                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                    future: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        return null;
                      }
                      return FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get();
                    }(),
                    builder: (context, snapshot) {
                      String displayName = "닉네임 없음";
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.exists) {
                        final data = snapshot.data!.data() ?? {};
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
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            if (!context.mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
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
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            if (currentUser != null) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser.uid)
                                  .delete();
                              await currentUser.delete();
                            }
                            if (!context.mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
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
