import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/repository/api/supermarket_api_client.dart';
import 'package:fluro_checkout/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const supermarketRepository =
        SupermarketRepository(supermarketApiClient: SupermarketApiClient());
    return BlocProvider(
      create: (context) =>
          SupermarketBloc(supermarketRepository: supermarketRepository),
      child: MaterialApp(
        title: 'Fluro Supermarket',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Fluro Supermarket'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
