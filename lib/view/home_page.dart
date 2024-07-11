import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/view/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Fluro Supermarket',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: SingleChildScrollView(
          child: BlocConsumer<SupermarketBloc, SupermarketState>(
            listener: (context, state) {
              if (state.status == SupermarketStatus.error) {
                if (state.errorMessage != null) {
                  final snackBar = SnackBar(
                    content: Text('${state.errorMessage}'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
            },
            builder: (context, state) {
              final status = state.status;
              if (status == SupermarketStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (status == SupermarketStatus.loaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProductsList(
                      products: state.products!,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text('Selected products: 0'),
                    ),
                  ],
                );
              } else if (status == SupermarketStatus.error) {
                return const Column(
                  children: [
                    Text('Error!'),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
