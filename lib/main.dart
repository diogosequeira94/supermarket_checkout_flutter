import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/repository/api/supermarket_api_client.dart';
import 'package:fluro_checkout/repository/repository.dart';
import 'package:fluro_checkout/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            supermarketRepository: context.read<SupermarketRepository>())
          ..add(
            const SupermarketLoadStarted(),
          ),
        child: MaterialApp(
          title: 'Fluro Supermarket',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
