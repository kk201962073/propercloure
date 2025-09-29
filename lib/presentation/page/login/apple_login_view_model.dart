import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppleLoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithApple() async {
    try {
      // Apple ID 로그인 요청
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
            scopes: [
              //AppleIDAuthorizationScopes.email,
              //AppleIDAuthorizationScopes.fullName,
            ],
          );

      print('Apple userIdentifier: ${credential.userIdentifier}');

      // [Optional] Firebase Authentication 연동
      final OAuthCredential authCredential = OAuthProvider("apple.com")
          .credential(
            idToken: credential.identityToken,
            accessToken: credential.authorizationCode,
          );

      final UserCredential user = await _auth.signInWithCredential(
        authCredential,
      );

      print('Firebase sign-in successful: ${user.user?.uid}');
    } on SignInWithAppleAuthorizationException catch (e) {
      // Apple 로그인 관련 에러 처리
      print('Apple sign-in error: $e');
    } catch (e) {
      // 기타 예외 처리
      print('Unknown error during sign-in: $e');
    }
  }
}
