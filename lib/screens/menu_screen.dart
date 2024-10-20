import 'package:flutter/material.dart';
import 'package:inventory_app/widgets/card_container.dart';
import 'package:inventory_app/widgets/menu_option.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Menú'),
      ),
      body: Center(
        child: CardContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona un módulo:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              MenuOption(
                icon: Icons.group,
                label: 'Proveedores',
                onPressed: () {
                  Navigator.pushNamed(context, 'suppliers');
                },
              ),
              const SizedBox(height: 20),
              MenuOption(
                icon: Icons.category,
                label: 'Categorías',
                onPressed: () {
                  Navigator.pushNamed(context, 'categories');
                },
              ),
              const SizedBox(height: 20),
              MenuOption(
                icon: Icons.shopping_cart,
                label: 'Productos',
                onPressed: () {
                  Navigator.pushNamed(context, 'products');
                },
              ),
            ],
          ),
        )
      ),
    );
  }
}
