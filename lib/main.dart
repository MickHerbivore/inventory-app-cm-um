import 'package:flutter/material.dart';
import 'package:inventory_app/routes/app_routes.dart';
import 'package:inventory_app/services/auth_service.dart';
import 'package:inventory_app/services/category_service.dart';
import 'package:inventory_app/services/product_service.dart';
import 'package:inventory_app/services/supplier_service.dart';
import 'package:inventory_app/theme/my_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ProductService()),
        ChangeNotifierProvider(create: (context) => CategoryService()),
        ChangeNotifierProvider(create: (context) => SupplierService()),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory App',
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerationRoute,
      theme: MyTheme.myTheme, 
    );
  }
}
