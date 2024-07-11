import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/repository/api/supermarket_api_client.dart';
import 'package:fluro_checkout/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'supermarket_splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SupermarketRepository(
          supermarketApiClient: const SupermarketApiClient()),
      child: BlocProvider(
        create: (context) => SupermarketBloc(
          supermarketRepository: context.read<SupermarketRepository>(),
        ),
        child: MaterialApp(
          title: 'Fluro Supermarket',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const SupermarketSplashScreen(),
        ),
      ),
    );
  }
}
