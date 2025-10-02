import 'package:cloud_firestore/cloud_firestore.dart';
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
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

      print('Apple userIdentifier: ${credential.userIdentifier}');

      // Firebase Authentication 연동
      final OAuthCredential authCredential = OAuthProvider("apple.com")
          .credential(
            idToken: credential.identityToken,
            accessToken: credential.authorizationCode,
          );

      final UserCredential user = await _auth.signInWithCredential(
        authCredential,
      );

      final currentUser = user.user;
      if (currentUser != null) {
        final userDocRef = FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid);
        final snapshot = await userDocRef.get();

        if (!snapshot.exists) {
          // 최초 로그인일 경우만 email/name 저장
          final email = credential.email ?? currentUser.email ?? "unknown";

          String fullName = "Apple User";
          if (credential.givenName != null && credential.familyName != null) {
            fullName = "${credential.givenName} ${credential.familyName}";
          } else if (credential.givenName != null) {
            fullName = credential.givenName!;
          } else if (credential.familyName != null) {
            fullName = credential.familyName!;
          } else if (currentUser.displayName != null) {
            fullName = currentUser.displayName!;
          }

          await userDocRef.set({
            "email": email,
            "name": fullName,
            "photoUrl": currentUser.photoURL,
            "createdAt": FieldValue.serverTimestamp(),
            "lastLogin": FieldValue.serverTimestamp(),
          });
        } else {
          // 이미 유저 문서가 있으면 lastLogin만 갱신
          await userDocRef.update({"lastLogin": FieldValue.serverTimestamp()});
        }
      }

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
