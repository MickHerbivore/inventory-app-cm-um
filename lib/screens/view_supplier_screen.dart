import 'package:flutter/material.dart';
import 'package:inventory_app/providers/supplier_form_provider.dart';
import 'package:inventory_app/screens/loading_screen.dart';
import 'package:inventory_app/services/supplier_service.dart';
import 'package:inventory_app/utils/dialog_utils.dart';
import 'package:inventory_app/widgets/card_container.dart';
import 'package:provider/provider.dart';

class ViewSupplierScreen extends StatelessWidget {
  const ViewSupplierScreen({super.key});
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
      child: _SupplierScreenBody(supplierService: supplierService),
    );
  }
}

class _SupplierScreenBody extends StatelessWidget {
  final SupplierService supplierService;

  const _SupplierScreenBody({
    required this.supplierService
    });
  
  @override
  Widget build(BuildContext context) {
    final supplierForm = Provider.of<SupplierFormProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedor'),
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
                    Icons.group,
                    color: Colors.grey,
                    size: 100,
                  ),
                )
              ),
              const SizedBox(height: 30),
              _SupplierForm(),
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
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            heroTag: 'edit',
            child: const Icon(Icons.edit), 
            onPressed: () async {
              
              if (!context.mounted) return;
              Navigator.pushNamed(context, 'edit-supplier', arguments: 'Editando');
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
                        text: supplier.supplierName,
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
                        text: supplier.supplierDescription,
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
                        text: 'Rut: ',
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text: supplier.supplierRut,
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
                        text: 'Dirección: ',
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text: supplier.supplierAddress,
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
                        text: 'Teléfono: ',
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text: supplier.supplierPhone,
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
                        text: 'Email: ',
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      TextSpan(
                        text: supplier.supplierEmail,
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
