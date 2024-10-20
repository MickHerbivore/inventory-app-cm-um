import 'package:flutter/material.dart';
import 'package:inventory_app/providers/supplier_form_provider.dart';
import 'package:inventory_app/screens/loading_screen.dart';
import 'package:inventory_app/services/supplier_service.dart';
import 'package:inventory_app/ui/input_decorations.dart';
import 'package:inventory_app/utils/dialog_utils.dart';
import 'package:inventory_app/widgets/card_container.dart';
import 'package:provider/provider.dart';

class EditSupplierScreen extends StatelessWidget {
  final String action;

  const EditSupplierScreen({
    super.key,
    required this.action,
  });
  
  @override
  Widget build(BuildContext context) {
    final supplierService = Provider.of<SupplierService>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SupplierFormProvider(supplierService.selectedSupplier!),
        ),
        ChangeNotifierProvider(
            create: (context) => SupplierService(),
        ),
      ],
      child: _SupplierScreenBody(supplierService: supplierService, action: action),
    );
  }
}

class _SupplierScreenBody extends StatelessWidget {
  final SupplierService supplierService;
  final String action;

  const _SupplierScreenBody({
    required this.supplierService,
    required this.action,
  });
  
  @override
  Widget build(BuildContext context) {
    final supplierForm = Provider.of<SupplierFormProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('$action Proveedor'),
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
                  margin: const EdgeInsets.only(top: 30),
                  child: const Icon(
                    Icons.group,
                    color: Colors.grey,
                    size: 100,
                  ),
                )
              ),
              const SizedBox(height: 20),
              _SupplierForm(),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          supplierService.selectedSupplier?.id != ''
          ? FloatingActionButton(
            onPressed: () async {
              final eliminar = await alertAction(
                context,
                'Eliminar',
                'Eliminar Proveedor',
                '¿Está seguro de eliminar este proveedor?'
              );

              if (!eliminar!) return;
              
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoadingScreen()),
              );
              
              await supplierService.deleteSupplier(supplierForm.supplier, context);
              
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
              if (!supplierForm.isValidForm()) return;
              
              final editar = action.toLowerCase() == 'editando'
              ? await alertAction(
                context,
                'Editar',
                'Editar Proveedor',
                '¿Está seguro de editar este proveedor?'
              ) : true;

              if (!editar!) return;
              
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoadingScreen()),
              );
              
              await supplierService.editOrCreateSupplier(supplierForm.supplier);
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

class _SupplierForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final supplierForm = Provider.of<SupplierFormProvider>(context);
    final supplier = supplierForm.supplier;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CardContainer(
        child: Form(
          key: supplierForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: Column(
              children: [
                TextFormField(
                  initialValue: supplier.supplierName,
                  onChanged: (value) => supplier.supplierName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'el nombre es obligatorio';
                    }
                    return null;
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hinText: 'Nombre del proveedor', 
                    labelText: 'Nombre',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  minLines: 1,
                  maxLines: 3,
                  initialValue: supplier.supplierDescription,
                  onChanged: (value) => supplier.supplierDescription = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hinText: 'Descripción del proveedor',
                    labelText: 'Descripción',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: supplier.supplierRut,
                  onChanged: (value) => supplier.supplierRut = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El RUT es obligatorio';
                    }
                    return null;
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hinText: 'Rut del proveedor',
                    labelText: 'Rut',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  minLines: 1,
                  maxLines: 3,
                  initialValue: supplier.supplierAddress,
                  onChanged: (value) => supplier.supplierAddress = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La dirección es obligatorio';
                    }
                    return null;
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hinText: 'Dirección del proveedor',
                    labelText: 'Dirección',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: supplier.supplierPhone,
                  onChanged: (value) => supplier.supplierPhone = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El teléfono es obligatorio';
                    }
                    return null;
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hinText: 'Teléfono del proveedor',
                    labelText: 'Teléfono',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  minLines: 1,
                  maxLines: 2,
                  initialValue: supplier.supplierEmail,
                  onChanged: (value) => supplier.supplierEmail = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El email es obligatorio';
                    }
                    return null;
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hinText: 'Email del proveedor',
                    labelText: 'Email',
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
