import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginViewModel {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google 로그인 화면 트리거
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      // Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase 자격 증명 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 인증
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      debugPrint('Google 로그인 오류: $e');
      return null;
    }
  }

  // Google 로그아웃
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('로그아웃 오류: $e');
    }
  }
}
