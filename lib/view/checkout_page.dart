import 'package:fluro_checkout/cubit/checkout_cubit.dart';
import 'package:fluro_checkout/view/widgets/selected_products_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CheckoutLoadInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CheckoutLoadSuccess) {
            return Column(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SelectedProductsList(
                        products: state.selectedProducts,
                        allowRemoval: false,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CheckoutLoadError) {
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
