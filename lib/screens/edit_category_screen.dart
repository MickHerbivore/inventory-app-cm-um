import 'package:flutter/material.dart';
import 'package:inventory_app/providers/category_form_provider.dart';
import 'package:inventory_app/screens/loading_screen.dart';
import 'package:inventory_app/services/category_service.dart';
import 'package:inventory_app/ui/input_decorations.dart';
import 'package:inventory_app/utils/dialog_utils.dart';
import 'package:inventory_app/widgets/card_container.dart';
import 'package:provider/provider.dart';

class EditCategoryScreen extends StatelessWidget {
  final String action;

  const EditCategoryScreen({
    super.key,
    required this.action,
  });

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
      child: _CategoryScreenBody(categoryService: categoryService, action: action),
    );
  }
}

class _CategoryScreenBody extends StatelessWidget {
  final CategoryService categoryService;
  final String action;

  const _CategoryScreenBody({
    required this.categoryService,
    required this.action,
  });
  
  @override
  Widget build(BuildContext context) {
    final categoryForm = Provider.of<CategoryFormProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('$action Categoria'),
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
          categoryService.selectedCategory?.id != ''
          ? FloatingActionButton(
            onPressed: () async {
              final eliminar = await alertAction(
                context,
                'Eliminar',
                'Eliminar categoría',
                '¿Está seguro de eliminar esta categoría?'
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
          )
          : const SizedBox(),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: 'edit',
            child: const Icon(Icons.save), 
            onPressed: () async {
              if (!categoryForm.isValidForm()) return;

              final editar = action.toLowerCase() == 'editando'
              ? await alertAction(
                context,
                'Editar',
                'Editar categoría',
                '¿Está seguro de editar esta categoría?'
              ) : true;

              if (!editar!) return;
              
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoadingScreen()),
              );

              await categoryService.editOrCreateCategory(categoryForm.category);
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
              children: [
                TextFormField(
                  initialValue: category.categoryName,
                  onChanged: (value) => category.categoryName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'el nombre es obligatorio';
                    }
                    return null;
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hinText: 'Nombre de la categoria', 
                    labelText: 'Nombre',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  minLines: 3,
                  maxLines: null,
                  initialValue: category.categoryDescription,
                  onChanged: (value) => category.categoryDescription = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hinText: 'Descripción de la categoria', 
                    labelText: 'Descripción',
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
