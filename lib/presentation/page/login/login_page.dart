import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/Home/home_page.dart';
import 'package:propercloure/presentation/page/login/google_login_view_model.dart';
import 'package:propercloure/presentation/page/login/apple_login_view_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginVM = GoogleLoginViewModel(); // Google 로그인 ViewModel
    final appleLoginVM = AppleLoginViewModel(); // Apple 로그인 ViewModel

    return Scaffold(
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
                        const SnackBar(content: Text('로그인에 실패했습니다.')),
                      );
                    }
                  },
                  child: Image.asset(
                    'assets/image/login.png',
                    width: 183,
                    height: 183,
                  ),
                ),
              ),

              // Remove extra spacing and move Apple button up with Transform
              Transform.translate(
                offset: const Offset(0, -40),
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        await appleLoginVM.signInWithApple();
                        // 로그인 성공 → HomePage로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      } catch (e) {
                        // 로그인 실패
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('로그인에 실패했습니다.')),
                        );
                      }
                    },
                    child: Image.asset(
                      'assets/image/applebutton.png',
                      width: 200,
                      height: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
