import 'package:flutter/material.dart';
import 'package:inventory_app/providers/product_form_provider.dart';
import 'package:inventory_app/screens/loading_screen.dart';
import 'package:inventory_app/services/category_service.dart';
import 'package:inventory_app/services/product_service.dart';
import 'package:inventory_app/utils/dialog_utils.dart';
import 'package:inventory_app/widgets/card_container.dart';
import 'package:inventory_app/widgets/product_image.dart';
import 'package:provider/provider.dart';

class ViewProductScreen extends StatelessWidget {
  const ViewProductScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductFormProvider(productService.selectedProduct!),
        ),
        ChangeNotifierProvider(
            create: (context) => CategoryService(),
        ),
      ],
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  final ProductService productService;

  const _ProductScreenBody({
    required this.productService
    });
  
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Producto'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CardContainer(
              child: Column(
                children: [
                  ProductImage(url: productService.selectedProduct!.productImage),
                  _ProductForm(),
                ]
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          productService.selectedProduct?.id != ''
          ? FloatingActionButton(
            onPressed: () async {
              final eliminar = await alertAction(
                context,
                'Eliminar',
                'Eliminar Producto',
                '¿Está seguro de eliminar este producto?'
              );

              if (!eliminar!) return;
              
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoadingScreen()),
              );
              
              await productService.deleteProduct(productForm.product, context);

              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            heroTag: 'delete',
            child: const Icon(Icons.delete_forever),
          )
          : const SizedBox(),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: 'edit',
            child: const Icon(Icons.edit), 
            onPressed: () async {
              if (!context.mounted) return;
              Navigator.pushNamed(context, 'edit-product', arguments: 'Editando');
            },
          ),
        ]
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    final categoryService = Provider.of<CategoryService>(context);

    return Form(
      key: productForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Nombre: ',
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  TextSpan(
                    text: product.productName,
                    style: const TextStyle(color: Colors.black)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Precio: ',
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  TextSpan(
                    text: '\$${product.productPrice}',
                    style: const TextStyle(color: Colors.black)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            categoryService.categories.isNotEmpty
            ? RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Categoría: ',
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  TextSpan(
                    text: (product.categoryId != ''
                      ? categoryService.categories.firstWhere((category) => category.id == product.categoryId).categoryName
                      : ''
                    ),
                    style: const TextStyle(color: Colors.black)
                  ),
                ],
              ),
            )
            : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
