import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/Home/home_page.dart';
import 'login_view_model.dart'; 

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginVM = LoginViewModel(); // ViewModel 인스턴스 생성

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/image/logo.png', width: 183, height: 183),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
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
                icon: const Icon(Icons.g_mobiledata),
                label: const Text("Google로 로그인"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
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
