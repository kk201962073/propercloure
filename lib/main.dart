import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propercloure/presentation/page/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Firestore connectivity check
  final db = FirebaseFirestore.instance;
  await db.collection('transactions').add({
    'connected': true,
    'timestamp': DateTime.now().toIso8601String(),
  });
  print("✅ Firestore 기본 연결 성공");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const LoginPage());
  }
}
