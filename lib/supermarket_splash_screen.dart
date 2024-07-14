import 'package:fluro_checkout/view/intro_page.dart';
import 'package:flutter/material.dart';

/// A non native SplashScreen
/// Added for demonstration purposes
class SupermarketSplashScreen extends StatefulWidget {
  const SupermarketSplashScreen({super.key});

  @override
  State<SupermarketSplashScreen> createState() =>
      _SupermarketSplashScreenState();
}

class _SupermarketSplashScreenState extends State<SupermarketSplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _navigateToNextPage() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const IntroPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), _navigateToNextPage);
    });
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 300,
              height: 300,
            ),
            const Text(
              'The Supermarket ®',
              style: TextStyle(
                fontSize: 24.0,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
