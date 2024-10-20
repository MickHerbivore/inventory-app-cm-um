import 'package:flutter/material.dart';
import 'package:inventory_app/models/models.dart';
import 'package:inventory_app/screens/loading_screen.dart';
import 'package:inventory_app/services/supplier_service.dart';
import 'package:inventory_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});
  @override
  SuppliersScreenState createState() => SuppliersScreenState();
}

class SuppliersScreenState extends State<SuppliersScreen> {
  String searchText = '';
  Supplier? selectedSupplier;

  @override
  Widget build(BuildContext context) {
    final supplierService = Provider.of<SupplierService>(context);

    if (supplierService.isLoading) return const LoadingScreen();

    final filteredSuppliers = supplierService.suppliers.where((supplier) {
      return supplier.supplierName.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: InputSearch(
                    text: 'Buscar proveedor...',	
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
      filteredSuppliers.isEmpty
      ? const Center(child: Text('No hay proveedores'))
      : ListView.separated(
        itemCount: filteredSuppliers.length,
        itemBuilder: (context, index) {
          final supplier = filteredSuppliers[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.group),
              title: Text(supplier.supplierName),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  supplierService.selectedSupplier = supplier.copy();
                  Navigator.pushNamed(context, 'edit-supplier', arguments: 'Editando');
                },
              ),
              onTap: () {
                supplierService.selectedSupplier = supplier.copy();
                Navigator.pushNamed(context, 'view-supplier');
              },
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          supplierService.selectedSupplier = Supplier(
            supplierName: '',
            supplierDescription: '',
            supplierRut: '',
            supplierAddress: '',
            supplierPhone: '',
            supplierEmail: '',
          );
          Navigator.pushNamed(context, 'edit-supplier', arguments: 'Creando');
        },
      )
    );
  }

}