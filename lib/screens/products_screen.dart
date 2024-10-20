import 'package:flutter/material.dart';
import 'package:inventory_app/models/models.dart';
import 'package:inventory_app/screens/loading_screen.dart';
import 'package:inventory_app/services/category_service.dart';
import 'package:inventory_app/services/product_service.dart';
import 'package:inventory_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  @override
  ProductsScreenState createState() => ProductsScreenState();
}

class ProductsScreenState extends State<ProductsScreen> {
  String searchText = '';
  Categoria? selectedCategory;
    final TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final categoryService = Provider.of<CategoryService>(context);

    if (productService.isLoading) return const LoadingScreen();

    final filteredProducts = productService.products.where((product) {
      final matchesName = product.productName.toLowerCase().contains(searchText.toLowerCase());
      final matchesCategory = selectedCategory == null || product.categoryId == selectedCategory!.id || selectedCategory!.id == "";
      return matchesName && matchesCategory;
    }).toList();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de guitarras'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(165.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: InputSearch(
                    text: 'Buscar producto...',
                    inputController: inputController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: DropdownButton<Categoria>(
                      hint: const Text('Seleccionar categoría'),
                      value: selectedCategory,
                      isExpanded: true,
                      items: categoryService.categories.map((category) {
                        return DropdownMenuItem<Categoria>(
                          value: category,
                          child: Text(category.categoryName),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: TextButton(
                    onPressed: () {
                        setState(() {
                          inputController.clear();
                          selectedCategory = null;
                          searchText = '';
                        });
                    },
                    child: const Text('Limpiar filtros'),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
      body: 
      filteredProducts.isEmpty
      ? const Center(child: Text('No hay productos'))
      : ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            productService.selectedProduct = filteredProducts[index].copy();
            Navigator.pushNamed(context, 'view-product');
          },
          child: ProductCard(
            product: filteredProducts[index],
            onTap: () {
              productService.selectedProduct = filteredProducts[index].copy();
              Navigator.pushNamed(context, 'edit-product', arguments: 'Editando');
            },
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productService.selectedProduct = Product(
            id: '',
            productName: '',
            productPrice: 0,
            productImage: 'https://as2.ftcdn.net/v2/jpg/02/51/95/53/1000_F_251955356_FAQH0U1y1TZw3ZcdPGybwUkH90a3VAhb.jpg',
            productState: '',
            categoryId: '',
          );
          Navigator.pushNamed(context, 'edit-product', arguments: 'Creando');
        },
      )
    );
  }

}