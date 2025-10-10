import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();

  // 🔹 유저 정보 가져오기
  Future<Map<String, dynamic>?> fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final snapshot = await _firestore.collection('users').doc(user.uid).get();
    return snapshot.data();
  }

  // 🔹 로그아웃 (Google + Apple)
  Future<void> logout() async {
    try {
      try {
        await _googleSignIn.signOut(); // Google 연결 해제
      } catch (_) {}
      await _auth.signOut(); // Firebase 세션 해제
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  // 🔹 회원탈퇴
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).delete();
    await user.delete();
  }
}
