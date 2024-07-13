import 'package:fluro_checkout/bloc/supermarket_bloc.dart';
import 'package:fluro_checkout/cubit/checkout_cubit.dart';
import 'package:fluro_checkout/repository/models/models.dart';
import 'package:fluro_checkout/repository/models/product/product.dart';
import 'package:fluro_checkout/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock_classes.dart';

void main() {
  const productsListKey = Key('productsList_key');
  const errorSnackBarKey = Key('checkoutButton_snackBar_key');
  const confirmationDialogKey = Key('confirmationDialog_key');
  const checkoutButtonKey = Key('checkoutButton_key');
  const totalPriceTextWidgetKey = Key('totalPriceText_key');
  const visibilityWidgetKey = Key('selectedProductsList_key');
  const errorWidgetKey = Key('errorWidget_key');

  late SupermarketBloc supermarketBloc;
  late CheckoutCubit checkoutCubit;
  late Widget widgetToTest;

  setUp(() {
    supermarketBloc = MockSupermarketBloc();
    checkoutCubit = MockCheckoutCubit();

    when(() => checkoutCubit.state).thenReturn(CheckoutState.initial());

    widgetToTest = MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => supermarketBloc,
        ),
        BlocProvider(
          create: (context) => checkoutCubit,
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: HomePage(),
        ),
      ),
    );
  });

  group('HomePage', () {
    group('Success', () {
      testWidgets('render success test', (tester) async {
        when(() => supermarketBloc.state).thenReturn(
          const SupermarketState(
            selectedProducts: [],
            status: SupermarketStatus.loaded,
          ),
        );

        await tester.pumpWidget(widgetToTest);
        await tester.pump();

        final productsListWidget = find.byKey(productsListKey);
        expect(productsListWidget, findsOneWidget);

        final checkoutButtonWidget = find.byKey(checkoutButtonKey);
        expect(checkoutButtonWidget, findsOneWidget);

        final visibilityWidget = find.byKey(visibilityWidgetKey);
        expect(visibilityWidget, findsOneWidget);

        final visibilityTesterWidget =
            tester.widget(visibilityWidget) as Visibility;
        expect(visibilityTesterWidget.visible, false);

        final totalTextWidget = find.byKey(totalPriceTextWidgetKey);
        expect(totalTextWidget, findsOneWidget);
      });

      testWidgets(
          'should render CircularProgressIndicator when status is loading',
          (tester) async {
        when(() => supermarketBloc.state).thenReturn(
          const SupermarketState(
            selectedProducts: [],
            status: SupermarketStatus.loading,
          ),
        );

        await tester.pumpWidget(widgetToTest);
        await tester.pump();

        final circularProgressIndicatorWidget =
            find.byType(CircularProgressIndicator);
        expect(circularProgressIndicatorWidget, findsOneWidget);
      });

      testWidgets('should render error widget when status is error',
          (tester) async {
        when(() => supermarketBloc.state).thenReturn(
          const SupermarketState(
            selectedProducts: [],
            status: SupermarketStatus.error,
          ),
        );

        await tester.pumpWidget(widgetToTest);
        await tester.pump();

        final errorWidget = find.byKey(errorWidgetKey);
        expect(errorWidget, findsOneWidget);
      });

      testWidgets(
          'should show SnackBar error when CheckoutButton is tapped and selected products are empty',
          (tester) async {
        when(() => supermarketBloc.state).thenReturn(
          const SupermarketState(
            selectedProducts: [],
            status: SupermarketStatus.loaded,
          ),
        );

        await tester.pumpWidget(widgetToTest);
        await tester.pump();

        final checkoutButtonWidget = find.byKey(checkoutButtonKey);
        expect(checkoutButtonWidget, findsOneWidget);

        final errorSnackBarWidget = find.byKey(errorSnackBarKey);
        expect(errorSnackBarWidget, findsNothing);

        final elevatedButtonWidget =
            tester.widget(checkoutButtonWidget) as ElevatedButton;
        elevatedButtonWidget.onPressed!();

        await tester.pumpWidget(widgetToTest);
        await tester.pump();
        expect(errorSnackBarWidget, findsOneWidget);
      });

      testWidgets(
          'should open checkout dialog when CheckoutButton is tapped and there are selected products',
          (tester) async {
        when(() => supermarketBloc.state).thenReturn(
          const SupermarketState(
            selectedProducts: [Product(name: 'A', price: 100, imageId: '')],
            status: SupermarketStatus.loaded,
          ),
        );

        await tester.pumpWidget(widgetToTest);
        await tester.pump();

        final checkoutButtonWidget = find.byKey(checkoutButtonKey);
        expect(checkoutButtonWidget, findsOneWidget);

        final elevatedButtonWidget =
            tester.widget(checkoutButtonWidget) as ElevatedButton;
        elevatedButtonWidget.onPressed!();

        await tester.pumpWidget(widgetToTest);
        await tester.pump();

        final confirmationDialogWidget = find.byKey(confirmationDialogKey);
        expect(confirmationDialogWidget, findsOneWidget);
      });
    });
  });
}
