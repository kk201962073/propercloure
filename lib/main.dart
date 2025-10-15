import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:propercloure/presentation/page/guitar/guitar_view_model.dart';
import 'package:propercloure/presentation/page/Home/home_view_model.dart';
import 'package:propercloure/presentation/page/minuse/minuse_view_model.dart';
import 'package:propercloure/presentation/page/property/propety_viwe_model.dart';
import 'package:propercloure/presentation/page/pulse/pulse_view_model.dart';
import 'package:propercloure/presentation/page/scren_theme/screntheme_view_model.dart';
import 'package:propercloure/presentation/page/splash/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PropertyViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => PulseViewModel()),
        ChangeNotifierProvider(create: (_) => MinuseViewModel()),
        ChangeNotifierProvider(create: (_) => GuitarViewModel()),
        ChangeNotifierProvider(create: (_) => ScrenThemeViewModel()),
        ChangeNotifierProvider(create: (_) => ScrenThemeViewModel()),
      ],
      child: Builder(
        builder: (context) {
          final isDark = context.watch<ScrenThemeViewModel>().isDarkMode;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.black),
                bodyLarge: TextStyle(color: Colors.black),
                titleMedium: TextStyle(color: Colors.black),
              ),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.blue,
                secondary: Colors.blueAccent,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Colors.white),
                titleMedium: TextStyle(color: Colors.white),
              ),
              colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
                  .copyWith(
                    primary: Colors.tealAccent,
                    secondary: Colors.blueGrey,
                  ),
            ),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
