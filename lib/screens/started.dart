import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartedScreen extends StatefulWidget {
  const StartedScreen({Key? key}) : super(key: key);

  @override
  _StartedScreenState createState() => _StartedScreenState();
}

class _StartedScreenState extends State<StartedScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  Widget _buildIntroduction(Icon icon, String title, String details) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const SizedBox(height: 24),
          icon,
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            details,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          if (_currentPage < 2) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            context.go('/signin');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          _currentPage < 2 ? "Next" : "Get Started",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.blue : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faker = Faker();
    final introductions = [
      _buildIntroduction(
        const Icon(Icons.heart_broken, color: Colors.red, size: 128),
        'Bien boire',
        faker.lorem.sentences(3).join(" "),
      ),
      _buildIntroduction(
        const Icon(Icons.local_drink, color: Colors.white, size: 128),
        'Rester Hydraté',
        faker.lorem.sentences(3).join(" "),
      ),
      _buildIntroduction(
        const Icon(Icons.water, color: Colors.blue, size: 128),
        'Objectifs quotidiens',
        faker.lorem.sentences(3).join(" "),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          if (_currentPage < introductions.length - 1)
            TextButton(
              onPressed: () {
                context.go('/signin');
              },
              child: const Text("skip", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: introductions,
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: _buildDots(introductions.length),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: _buildNextButton(),
            ),
          ],
        ),
      ),
    );
  }
}
