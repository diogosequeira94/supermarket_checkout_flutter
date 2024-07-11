import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This is not a native splashScreen
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
    final supermarketBloc = context.read<SupermarketBloc>();
    supermarketBloc.add(const SupermarketLoadStarted());
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
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
            Image.asset('assets/logo.png'),
            const SizedBox(height: 16.0),
            const Text(
              'Fluro Supermarket',
              style: TextStyle(
                fontSize: 28.0,
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
