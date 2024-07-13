import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/cubit/checkout_cubit.dart';
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
      body: BlocListener<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state.checkoutInProgress) {
            const snackBar = SnackBar(
              duration: Duration(seconds: 1),
              content: Text('Thanks for shopping with us!'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: BlocConsumer<SupermarketBloc, SupermarketState>(
          listener: (context, state) {
            if (state.status == SupermarketStatus.error) {
              if (state.errorMessage != null) {
                final snackBar = SnackBar(
                  duration: const Duration(seconds: 1),
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
                          _SelectedProductsList(),
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
                              _TotalPriceTextWidget(),
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
                        ElevatedButton(
                          onPressed: () {
                            if (state.selectedProducts.isEmpty) {
                              const snackBar = SnackBar(
                                content: Text(
                                    'Please select some products first :)'),
                                duration: Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              _openCheckoutConfirmationDialog(context);
                            }
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
      ),
    );
  }

  void _openCheckoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout & Pay'),
          content: const Text(
            'By checking out and paying you will finish your shopping.\n\n'
            'You will start a new process and check new promotions.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
                context
                    .read<SupermarketBloc>()
                    .add(const SupermarketFinishShopPressed());
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _TotalPriceTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        return Text(
          key: const Key('totalPriceText_key'),
          'Total: ${state.totalAmount.toString()}p',
          style: const TextStyle(fontSize: 18.0),
        );
      },
    );
  }
}

class _SelectedProductsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        return Visibility(
          key: const Key('selectedProductsList_key'),
          visible: state.selectedProductsWithAppliedPromotions.isNotEmpty,
          child: SelectedProductsList(
            products: state.selectedProductsWithAppliedPromotions,
          ),
        );
      },
    );
  }
}
