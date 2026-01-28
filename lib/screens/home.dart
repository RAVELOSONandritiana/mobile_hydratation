import 'package:flutter/material.dart';
import 'package:hydratation/screens/community.dart';
import 'package:hydratation/screens/history.dart';
import 'package:hydratation/screens/indicator.dart';
import 'package:hydratation/screens/reminders.dart';
import 'package:hydratation/screens/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value){
          setState(() {
            _currentPage = value;
          });
        },
        children: [
          IndicatorScreen(),
          CommunityScreen(),
          History(),
          RemindersScreen(),
          Settings()
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentPage,
          onDestinationSelected: (index) {
            setState(() {
              _currentPage = index;
              _pageController.animateToPage(
                _currentPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          backgroundColor: Colors.black,
          elevation: 0,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold);
            }
            return TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10);
          }),
          indicatorColor: Colors.blue.withOpacity(0.1),
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.water_drop_outlined, color: Colors.white.withOpacity(0.5)),
              selectedIcon: const Icon(Icons.water_drop, color: Colors.blue),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline, color: Colors.white.withOpacity(0.5)),
              selectedIcon: const Icon(Icons.people, color: Colors.blue),
              label: 'Social',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined, color: Colors.white.withOpacity(0.5)),
              selectedIcon: const Icon(Icons.bar_chart, color: Colors.blue),
              label: 'Stats',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined, color: Colors.white.withOpacity(0.5)),
              selectedIcon: const Icon(Icons.notifications, color: Colors.blue),
              label: 'Tips',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: Colors.white.withOpacity(0.5)),
              selectedIcon: const Icon(Icons.settings, color: Colors.blue),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
