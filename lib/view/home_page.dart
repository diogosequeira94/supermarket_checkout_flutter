import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/view/widgets/widgets.dart';
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
      body: BlocConsumer<SupermarketBloc, SupermarketState>(
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
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ProductsList(
                          products: state.products!,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                              'Selected products: ${state.selectedProducts.length}'),
                        ),
                        if (state.selectedProducts.isNotEmpty)
                          SelectedProductsList(
                              products: state.selectedProducts),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.orangeAccent,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total: ${state.totalAmount.toString()}p',
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            const SizedBox(height: 4.0),
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4.0),
                                Flexible(
                                  child: Text(
                                    'Promotions are calculated automatically',
                                    style: TextStyle(color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (status == SupermarketStatus.error) {
            return const Center(
              child: Text('Error!'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
