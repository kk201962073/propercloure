import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:propercloure/presentation/page/login/login_page.dart';
import 'package:propercloure/presentation/page/Home/home_view_model.dart';
import 'package:propercloure/presentation/page/property/propety_viwe_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PropertyViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
      ),
    );
  }
}
