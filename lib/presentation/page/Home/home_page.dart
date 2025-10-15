import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:propercloure/presentation/page/Home/home_view_model.dart';
import 'package:propercloure/presentation/page/property/propety_viwe_model.dart';
import 'package:propercloure/presentation/page/add/add_page.dart';
import 'package:propercloure/presentation/page/property/propety_page.dart';
import 'package:propercloure/presentation/page/profile/profile_page.dart';
import 'package:propercloure/presentation/page/ai/ai_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'widgets/home_header_widget.dart';
import 'widgets/home_calendar_widget.dart';
import 'widgets/home_transaction_list_widget.dart';

class HomePage extends StatefulWidget {
  final bool hasExpense;
  const HomePage({super.key, this.hasExpense = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      final propertyViewModel = Provider.of<PropertyViewModel>(
        context,
        listen: false,
      );
      final user = fb_auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        homeViewModel.loadTransactions(user.uid, propertyViewModel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeaderWidget(),
                const SizedBox(height: 16),
                const HomeCalendarWidget(),
                const SizedBox(height: 50),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: const HomeTransactionListWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Map<String, dynamic>?>(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(initialDate: viewModel.selectedDay),
            ),
          );

          if (!context.mounted) return;

          if (result != null) {
            final titleDynamic = result['title'];
            final String title = titleDynamic is String
                ? titleDynamic
                : titleDynamic is Map
                ? (titleDynamic['name'] ?? '')
                : '';

            final dynamic amountDynamic = result['amount'];
            int amount = 0;
            if (amountDynamic is int) {
              amount = amountDynamic;
            } else if (amountDynamic is String) {
              amount = int.tryParse(amountDynamic) ?? 0;
            }

            final dynamic categoryDynamic = result['category'];
            final String category = categoryDynamic is String
                ? categoryDynamic
                : categoryDynamic is Map
                ? (categoryDynamic['name'] ?? '')
                : '';

            final dynamic dateDynamic = result['date'];
            DateTime date = viewModel.selectedDay;
            if (dateDynamic is DateTime) {
              date = dateDynamic;
            } else if (dateDynamic is String) {
              try {
                date = DateTime.parse(dateDynamic);
              } catch (_) {}
            }

            final safeTitle = title.isNotEmpty ? title : '제목 없음';
            final safeCategory = category.isNotEmpty ? category : '기타';

            viewModel.setSelectedDay(date);
            final user = fb_auth.FirebaseAuth.instance.currentUser;
            if (user != null) {
              await viewModel.addTransaction(
                user.uid,
                safeTitle,
                amount,
                safeCategory,
                date,
              );
            }
          }
        },
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.blue
            : Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                icon: Image.asset(
                  "assets/image/calender.png",
                  width: 64,
                  height: 64,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PropertyPage(),
                    ),
                  );
                },
                icon: Image.asset(
                  "assets/image/money.png",
                  width: 64,
                  height: 64,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AiPage()),
                  );
                },
                icon: Image.asset("assets/image/ai.png", width: 64, height: 64),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                icon: Image.asset(
                  "assets/image/profile.png",
                  width: 64,
                  height: 64,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
