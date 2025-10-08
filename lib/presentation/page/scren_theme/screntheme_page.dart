import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/scren_theme/screntheme_view_model.dart';
import 'package:provider/provider.dart';

class ScrenThemePage extends StatefulWidget {
  const ScrenThemePage({Key? key}) : super(key: key);

  @override
  _ScrenThemePageState createState() => _ScrenThemePageState();
}

class _ScrenThemePageState extends State<ScrenThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<ScrenThemeViewModel>().isDarkMode
          ? Colors.black
          : Colors.white,
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('화면 테마'),
        backgroundColor: context.watch<ScrenThemeViewModel>().isDarkMode
            ? Colors.black
            : Colors.white,
        foregroundColor: context.watch<ScrenThemeViewModel>().isDarkMode
            ? Colors.white
            : Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 245),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:
                      context.watch<ScrenThemeViewModel>().isDarkMode
                      ? Colors.black
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(
                    color: context.watch<ScrenThemeViewModel>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                onPressed: () {
                  context.read<ScrenThemeViewModel>().toggleTheme(false);
                },
                child: Text(
                  '라이트 모드',
                  style: TextStyle(
                    color: context.watch<ScrenThemeViewModel>().isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:
                      context.watch<ScrenThemeViewModel>().isDarkMode
                      ? Colors.white
                      : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  context.read<ScrenThemeViewModel>().toggleTheme(true);
                },
                child: Text(
                  '다크모드',
                  style: TextStyle(
                    color: context.watch<ScrenThemeViewModel>().isDarkMode
                        ? Colors.black
                        : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
