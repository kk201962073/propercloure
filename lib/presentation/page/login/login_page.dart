import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/Home/home_page.dart';
import 'package:propercloure/presentation/page/login/google_login_view_model.dart';
import 'package:propercloure/presentation/page/login/apple_login_view_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final loginVM = GoogleLoginViewModel(); // Google 로그인 ViewModel
    final appleLoginVM = AppleLoginViewModel(); // Apple 로그인 ViewModel

    return FutureBuilder<User?>(
      future: _getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          // 이미 로그인 상태면 바로 HomePage로 이동
          return const HomePage();
        }
        // 로그인 UI
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 로고
                  Image.asset('assets/image/logo.png', width: 183, height: 183),

                  const SizedBox(height: 24),

                  // Google 로그인 버튼
                  Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: () async {
                        final userCredential = await loginVM.signInWithGoogle();
                        if (userCredential != null) {
                          // 로그인 성공 → HomePage로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        } else {
                          // 로그인 실패
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '로그인에 실패했습니다.',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: Image.asset(
                          'assets/image/login.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: () async {
                        final user = await appleLoginVM.signInWithApple();
                        if (user != null) {
                          // 로그인 성공 → HomePage로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        } else {
                          // 로그인 실패 → 현재 페이지에 머물고 SnackBar 표시
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '로그인에 실패했습니다. 다시 시도해주세요.',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                              backgroundColor: Colors.redAccent,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: SizedBox(
                        width: 250,
                        height: 50,
                        child: Image.asset(
                          'assets/image/applebutton.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
