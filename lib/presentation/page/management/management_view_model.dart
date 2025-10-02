import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagementViewModel extends ChangeNotifier {
  String name = '';
  String email = '';
  String photoUrl = '';
  bool isLoading = true;

  ManagementViewModel() {
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      name = data["name"] ?? "이름 없음";
      email = data["email"] ?? "이메일 없음";
      photoUrl = data["photoUrl"] ?? "";
    }
    isLoading = false;
    notifyListeners();
  }
}
