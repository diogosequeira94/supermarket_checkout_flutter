import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/view/widgets/products_list.dart';
import 'package:fluro_checkout/view/widgets/selected_products_list.dart';
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
                      const Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total: 0',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                    width:
                                        4.0), // Add some spacing between icon and text
                                Flexible(
                                  child: Text(
                                    'Promotions are calculated on checkout',
                                    style: TextStyle(
                                        color: Colors
                                            .black), // Ensure the text color is visible
                                    maxLines:
                                        2, // You can adjust this to the desired number of lines
                                    overflow: TextOverflow
                                        .ellipsis, // Add ellipsis if the text overflows
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Your onPressed code here
                        },
                        child: const Text('Checkout'),
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
