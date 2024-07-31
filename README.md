# Supermarket Checkout

Supermarket Checkout is an application that allows you to buy your favorite products (SKUs)! You can scan (add) products to your ShoppingCart, enjoy promotions, and proceed to checkout.

## Features

- Add products to your shopping cart by scanning SKUs
- Enjoy various promotions and discounts (MultiPriced, BuyNGetFree and MealDeals)
- Information about your promotions on the fly
- Proceed to checkout (start a new shopping session)
- Fetches the SpecialOffers/Promotions on every checkout completed (as promotions can change, this way we ensure we get a fresh and valid list).

## PreRequisites

Before you begin, ensure you have Dart and Flutter installed on your local machine.

### Install Dart and Flutter

Follow the official installation guides:

- [Install Dart](https://dart.dev/get-dart)
- [Install Flutter](https://flutter.dev/docs/get-started/install)

## Flutter Version

This project requires Flutter version `>=3.3.3 <4.0.0`. Please ensure you have a compatible version installed.

To check your Flutter version, run:
```sh
flutter --version
```

## Setup

### 1. Get dependencies

Navigate to the project directory and install the required dependencies; You can run the following command:

```sh
flutter pub get
```

### 2. Run the project

You can run the project on an emulator or a physical device with the following command:
```sh
flutter run
```

### 3. Run tests

To check existing unit/widget tests that can be checked by running:
```sh
flutter test
```

## Structure overview

```
  fluro_checkout/
    ├── lib/
    │   ├── src/
    │   │   ├── bloc/
    │   │   │   ├── supermarket_bloc.dart
    │   │   │   ├── supermarket_event.dart
    │   │   │   ├── supermarket_state.dart      
    │   │   ├── cubit/
    │   │   │   ├── checkout_cubit.dart
    │   │   │   ├── checkout_state.dart
    │   │   ├── model/
    │   │   │   ├── selected_product.dart     
    │   │   ├── repository/
    │   │   │   │   ├── api/
    │   │   │   │   │   ├── supermarket_api_client.dart        
    │   │   │   │   ├── data/
    │   │   │   │   │   ├── mock-products.json
    │   │   │   │   │   ├── mock-special-prices.json  
    │   │   │   │   │   ├── mock-supermarket-info-response.json
    │   │   │   │   ├── errors/
    │   │   │   │   │   ├── errors.dart
    │   │   │   │   │   ├── supermarket_exception.dart 
    │   │   │   │   ├── models/
    |   │   │   │   │   │   ├── product/ ---> model classes that are part of a product
    |   │   │   │   │   │   ├── special_price/ ---> model classes that are part of promotion
    │   │   │   │   │   ├── models.dart
    │   │   │   │   │   ├── supermarket_info_response.dart 
    │   │   │   │   │   ├── supermarket_info_response.g
    │   │   │   │   ├── repository.dart ---> barrel file
    │   │   │   │   ├── supermarket_repository.dart
    │   │   ├── view/
    │   │   │   │   ├── widgets/ ---> widgets that compose the UI of home_page     
    │   │   │   │   ├── home_page.dart
    │   │   │   │   ├── intro_page.dart
    │   ├── main.dart
    │   ├── super_market_splash_screen.dart
    ├── test/
    │   ├── unit_test/
    │   ├── widget_test/
    ├── .gitignore
    ├── analysis_options.yaml
    ├── pubspec.yaml
    └── README.md
```
