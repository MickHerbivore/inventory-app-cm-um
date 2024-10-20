import 'package:flutter/material.dart';
import 'package:inventory_app/screens/register_user_screen.dart';

import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'login';

  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'add-user': (BuildContext context) => const RegisterUserScreen(),
    'menu': (BuildContext context) => const MenuScreen(),
    'products': (BuildContext context) => const ProductsScreen(),
    'edit-product': (BuildContext context) {
      final action = ModalRoute.of(context)!.settings.arguments as String;
      return EditProductScreen(action: action);
    },
    'view-product': (BuildContext context) => const ViewProductScreen(),
    'categories': (BuildContext context) => const CategoriesScreen(),
    'view-category': (BuildContext context) => const ViewCategoryScreen(),
    'edit-category': (BuildContext context) {
      final action = ModalRoute.of(context)!.settings.arguments as String;
      return EditCategoryScreen(action: action);
    },
    'suppliers': (BuildContext context) => const SuppliersScreen(),
    'edit-supplier': (BuildContext context) {
      final action = ModalRoute.of(context)!.settings.arguments as String;
      return EditSupplierScreen(action: action);
    },
    'view-supplier': (BuildContext context) => const ViewSupplierScreen(),
  };

  static Route<dynamic> onGenerationRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen()
    );
  }
}