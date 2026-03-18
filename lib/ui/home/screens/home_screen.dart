import 'package:flutter/material.dart';

import '../../loans/screens/my_loans_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/home_scoring_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = 'home';
  static const routePath = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                if (_currentIndex != 2)
                  HomeHeader(
                    title: _currentIndex == 0
                        ? 'Tu Scoring Crediticio'
                        : 'Solicitudes de crédito',
                    onBack: () {},
                    onInfo: () {},
                  ),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      const HomeScoringView(),
                      const MyLoansScreen(),
                      const ProfileScreen(),
                    ],
                  ),
                ),
                HomeBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
