import 'package:flutter/material.dart';
import 'package:inventory_app/models/category.dart';
import 'package:inventory_app/providers/product_form_provider.dart';
import 'package:inventory_app/screens/loading_screen.dart';
import 'package:inventory_app/services/category_service.dart';
import 'package:inventory_app/services/product_service.dart';
import 'package:inventory_app/ui/input_decorations.dart';
import 'package:inventory_app/utils/dialog_utils.dart';
import 'package:inventory_app/widgets/card_container.dart';
import 'package:inventory_app/widgets/product_image.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  final String action;

  const EditProductScreen({
    super.key,
    required this.action,
  });

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
      child: _ProductScreenBody(productService: productService, action: action),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  final ProductService productService;
  final String action;

  const _ProductScreenBody({
    required this.productService,
    required this.action,
  });
  
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('$action Producto'),
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
            child: const Icon(Icons.save), 
            onPressed: () async {
              if (!productForm.isValidForm()) return;
              
              final editar = action.toLowerCase() == 'editando'
                ? await alertAction(
                  context,
                  'Editar',
                  'Editar Producto',
                  '¿Está seguro de editar este producto?'
                ) : true;

              if (!editar!) return;
              
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoadingScreen()),
              );
              
              await productService.editOrCreateProduct(productForm.product);
              if (!context.mounted) return;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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
          children: [
            TextFormField(
              initialValue: product.productImage,
              onChanged: (value) => product.productImage = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'la url es obligatoria';
                }
                return null;
              },
              decoration: InputDecorations.authInputDecoration(
                hinText: 'url',
                labelText: 'imagen',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: product.productName,
              onChanged: (value) => product.productName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'el nombre es obligatorio';
                }
                return null;
              },
              decoration: InputDecorations.authInputDecoration(
                hinText: 'Nombre del producto',
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              initialValue: product.productPrice.toString(),
              onChanged: (value) {
                if (int.tryParse(value) == null) {
                  product.productPrice = 0;
                } else {
                  product.productPrice = int.parse(value);
                }
              },
              decoration: InputDecorations.authInputDecoration(
                hinText: '-----',
                labelText: 'Precio',
              ),
            ),
            const SizedBox(height: 20),
            categoryService.isLoading 
              ? const CircularProgressIndicator()
              : DropdownButtonFormField<Categoria>(
                  value: (product.categoryId != ''
                    ? categoryService.categories.firstWhere((category) => category.id == product.categoryId)
                    : null
                  ),
                  items: categoryService.categories.map((category) {
                    return DropdownMenuItem<Categoria>(
                      value: category,
                      child: Text(category.categoryName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    categoryService.selectedCategory = value;
                    product.categoryId = value!.id;
                  },
                  decoration: InputDecorations.authInputDecoration(
                    labelText: 'Categoría',
                    hinText: 'Seleccionar categoría',
                  ),
                ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _createDecoration() => const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 5),
              blurRadius: 10,
            )
          ]);
}
