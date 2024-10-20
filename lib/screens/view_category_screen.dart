import 'package:flutter/material.dart';
import 'package:inventory_app/providers/category_form_provider.dart';
import 'package:inventory_app/screens/loading_screen.dart';
import 'package:inventory_app/services/category_service.dart';
import 'package:inventory_app/utils/dialog_utils.dart';
import 'package:inventory_app/widgets/card_container.dart';
import 'package:provider/provider.dart';

class ViewCategoryScreen extends StatelessWidget {
  const ViewCategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoryFormProvider(categoryService.selectedCategory!),
        ),
        ChangeNotifierProvider(
            create: (context) => CategoryService(),
        ),
      ],
      child: _CategoryScreenBody(categoryService: categoryService),
    );
  }
}

class _CategoryScreenBody extends StatelessWidget {
  final CategoryService categoryService;

  const _CategoryScreenBody({
    required this.categoryService
    });
  
  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<CategoryFormProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categoria'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SafeArea(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 50),
                  child: const Icon(
                    Icons.category,
                    color: Colors.grey,
                    size: 100,
                  ),
                )
              ),
              const SizedBox(height: 30),
              _CategoryForm(),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final eliminar = await alertAction(
                context,
                'Eliminar',
                'Eliminar Categoría',
                '¿Está seguro de eliminar este categoría?'
              );

              if (!eliminar!) return;
              
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoadingScreen()),
              );
              
              await categoryService.deleteCategory(categoryForm.category, context);

              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            heroTag: 'delete',
            child: const Icon(Icons.delete_forever),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: 'edit',
            child: const Icon(Icons.edit), 
            onPressed: () async {
              
              if (!context.mounted) return;
              Navigator.pushNamed(context, 'edit-category', arguments: 'Editando');
            },
          ),
        ]
      ),
    );
  }
}

class _CategoryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<CategoryFormProvider>(context);
    final category = categoryForm.category;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CardContainer(
        child: Form(
          key: categoryForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Nombre: ',
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text: category.categoryName,
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
                        text: 'Descripción: ',
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text: category.categoryDescription,
                        style: const TextStyle(color: Colors.black)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
