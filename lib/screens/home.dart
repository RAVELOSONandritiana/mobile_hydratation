import 'package:flutter/material.dart';
import 'package:hydratation/screens/history.dart';
import 'package:hydratation/screens/indicator.dart';
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
          History(),
          Settings()
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPage,
        onDestinationSelected: (index){
          setState(() {
            _currentPage = index;
            _pageController.jumpToPage(_currentPage);
          });
        },
        labelTextStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white)),
        indicatorColor: Colors.blue,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.water_drop, color: Colors.white),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt, color: Colors.white),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, color: Colors.white),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
