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

      final OAuthCredential authCredential = OAuthProvider("apple.com")
          .credential(
            idToken: credential.identityToken,
            accessToken: credential.authorizationCode,
          );

      final UserCredential userCredential = await _auth.signInWithCredential(
        authCredential,
      );

      final currentUser = userCredential.user;
      if (currentUser != null) {
        final userDocRef = FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid);
        final snapshot = await userDocRef.get();

        if (!snapshot.exists) {
          final email = credential.email ?? currentUser.email ?? "unknown";
          String fullName =
              currentUser.displayName ??
              "${credential.givenName ?? ''} ${credential.familyName ?? ''}"
                  .trim();

          await userDocRef.set({
            "email": email,
            "name": fullName.isEmpty ? "Apple User" : fullName,
            "photoUrl": currentUser.photoURL,
            "createdAt": FieldValue.serverTimestamp(),
            "lastLogin": FieldValue.serverTimestamp(),
          });
        } else {
          await userDocRef.update({"lastLogin": FieldValue.serverTimestamp()});
        }

        print('✅ Firebase sign-in successful: ${currentUser.uid}');
        return currentUser;
      }

      return null;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        print('🚫 사용자가 Apple 로그인을 취소했습니다.');
      } else {
        print('❌ Apple sign-in error: $e');
      }
      return null;
    } catch (e) {
      print('❌ Unknown error during sign-in: $e');
      return null;
    }
  }
}
