import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppleLoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

      print('Apple userIdentifier: ${credential.userIdentifier}');
      print('Apple email: ${credential.email}');
      print('Apple fullName: ${credential.givenName} ${credential.familyName}');

      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        oAuthCredential,
      );

      final currentUser = userCredential.user;
      if (currentUser == null) {
        print('Firebase user is null after Apple sign-in.');
        return null;
      }

      final userRef = FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid);
      final docSnapshot = await userRef.get();

      final email = credential.email ?? currentUser.email ?? "비공개 이메일";
      final fullName =
          (credential.givenName != null || credential.familyName != null)
          ? "${credential.givenName ?? ''} ${credential.familyName ?? ''}"
                .trim()
          : currentUser.displayName ?? "Apple 사용자";

      if (!docSnapshot.exists) {
        await userRef.set({
          "email": email,
          "name": fullName,
          "provider": "apple.com",
          "createdAt": FieldValue.serverTimestamp(),
          "lastLogin": FieldValue.serverTimestamp(),
        });
        print('새 Apple 사용자 문서 생성 완료');
      } else {
        await userRef.update({
          "lastLogin": FieldValue.serverTimestamp(),
          "provider": "apple.com",
        });
        print('기존 Apple 사용자 로그인 시간 갱신');
      }

      print('Firebase sign-in successful: ${currentUser.uid}');
      print(
        'Provider data: ${currentUser.providerData.map((e) => e.providerId).toList()}',
      );
      return currentUser;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        print('사용자가 Apple 로그인을 취소했습니다.');
      } else {
        print('Apple sign-in error: $e');
      }
      return null;
    } catch (e) {
      print('Unknown Apple sign-in error: $e');
      return null;
    }
  }

  Future<void> deleteAppleAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint(' No logged-in user.');
        return;
      }

      //Apple 재인증 (authorizationCode 재발급)
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await user.reauthenticateWithCredential(oAuthCredential);
      debugPrint(' Reauthenticated successfully.');

      // 2️ Firebase 유저 삭제
      await user.delete();
      debugPrint('Firebase account deleted.');

      //  Apple 동의화면 복원을 위해, 기기 설정에서 Apple ID 연결 해제 필요
      debugPrint(
        'Please unlink Apple ID in device settings to fully reset consent.',
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        debugPrint(' Apple authorization canceled by user.');
      } else {
        debugPrint(' Apple authorization error: $e');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        debugPrint(' 재로그인이 필요합니다. Apple로 다시 로그인 후 시도하세요.');
      } else {
        debugPrint(' Firebase Auth error: ${e.code}');
      }
    } catch (e) {
      debugPrint(' Unknown delete account error: $e');
    }
  }
}
