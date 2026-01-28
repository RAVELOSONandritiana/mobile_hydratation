import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydratation/services/notification_service.dart';
import 'package:hydratation/providers/compte_provider.dart';
import 'package:hydratation/providers/indicator_provider.dart';
import 'package:hydratation/providers/name_provider.dart';
import 'package:hydratation/screens/home.dart';
import 'package:hydratation/screens/signin.dart';
import 'package:hydratation/screens/signup.dart';
import 'package:hydratation/screens/splash.dart';
import 'package:hydratation/screens/started.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NameProvider()),
        ChangeNotifierProvider(create: (_) => IndicatorProvider()),
        ChangeNotifierProvider(create: (_) => CompteProvider()),
      ],
      child: MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, _) => SplashScreen()),
    GoRoute(path: '/home', builder: (_, _) => HomeScreen()),
    GoRoute(path: '/started', builder: (_, _) => StartedScreen()),
    GoRoute(path: '/signin', builder: (_, _) => Signin()),
    GoRoute(path: '/signup', builder: (_, _) => Signup()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          titleSpacing: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
