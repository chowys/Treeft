import 'package:flutter/material.dart';
import 'package:code/Models/models.dart';
import '/Page/Screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return Homescreen.route();
      case Homescreen.routeName:
        return Homescreen.route();
      case LogIn.routeName:
        return LogIn.route();
      case Catalog.routeName:
        return Catalog.route(category: settings.arguments as Category);
      case ProductPage.routeName:
        return ProductPage.route(product: settings.arguments as Product);
      case WishList.routeName:
        return WishList.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
