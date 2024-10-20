import 'package:flutter/material.dart';
import 'package:inventory_app/models/models.dart';
import 'package:inventory_app/screens/loading_screen.dart';
import 'package:inventory_app/services/category_service.dart';
import 'package:inventory_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  CategoriesScreenState createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  String searchText = '';
  Categoria? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);

    if (categoryService.isLoading) return const LoadingScreen();

    final filteredCategories = categoryService.categories.where((category) {
      return category.categoryName.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: InputSearch(
                    text: 'Buscar categoría...',
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    }
                  )
                ),
              ],
            ),
          )
        ),
      ),
      body: 
      filteredCategories.isEmpty
      ? const Center(child: Text('No hay categorías'))
      : ListView.separated(
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) {
          final category = filteredCategories[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.category),
              title: Text(category.categoryName),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  categoryService.selectedCategory = category.copy();
                  Navigator.pushNamed(context, 'edit-category', arguments: 'Editando');
                },
              ),
              onTap: () {
                categoryService.selectedCategory = category.copy();
                Navigator.pushNamed(context, 'view-category');
              },
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          categoryService.selectedCategory = Categoria(
            categoryName: '',
            categoryDescription: '',
          );
          Navigator.pushNamed(context, 'edit-category', arguments: 'Creando');
        },
      )
    );
  }

}