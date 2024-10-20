import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/models/supplier.dart';
import 'package:inventory_app/services/auth_service.dart';

class SupplierService extends ChangeNotifier {
  final String _baseUrl = 'firestore.googleapis.com';
  final String _baseEndpoint = '/v1/projects/back-cm-um/databases/(default)/documents/';

  List<Supplier> suppliers = [];
  Supplier? selectedSupplier;
  bool isLoading = true;
  bool isEditCreate = true;

  SupplierService() {
    loadSuppliers();
  }
  
  Future loadSuppliers() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(
      _baseUrl,
      '${_baseEndpoint}suppliers/',
    );

    String basicAuth = 'Bearer ${TokenStorage.token}';
    final response = await http.get(url, headers: {'Authorization': basicAuth});
    final suppliersMap = SupplierList.fromMap(json.decode(response.body));
    suppliers = suppliersMap.listado;
    isLoading = false;
    notifyListeners();
  }

  Future editOrCreateSupplier(Supplier supplier) async {
    isEditCreate = true;
    notifyListeners();
    if (supplier.id.isEmpty) { 
      await createSupplier(supplier);
    } else {
      await updateSupplier(supplier);
    }

    isEditCreate = false;
    loadSuppliers();
    notifyListeners();
  }

  Future<String> updateSupplier(Supplier supplier) async {
     final url = Uri.https(
      _baseUrl,
      '${_baseEndpoint}suppliers/${supplier.id}',
    );

    String basicAuth = 'Bearer ${TokenStorage.token}';

    var supplierData = {
      "fields": {
        "supplierName": {"stringValue": supplier.supplierName},
        "supplierDescription": {"stringValue": supplier.supplierDescription},
        "supplierRut": {"stringValue": supplier.supplierRut},
        "supplierAddress": {"stringValue": supplier.supplierAddress},
        "supplierPhone": {"stringValue": supplier.supplierPhone},
        "supplierEmail": {"stringValue": supplier.supplierEmail},
      }
    };

    await http.patch(url, body: json.encode(supplierData), headers: {
      'authorization': basicAuth,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    final index = suppliers
        .indexWhere((element) => element.id == supplier.id);
    suppliers[index] = supplier;

    return '';
  }

  Future createSupplier(Supplier supplier) async {
    final url = Uri.https(
      _baseUrl,
      '${_baseEndpoint}suppliers/',
    );

    String basicAuth = 'Bearer ${TokenStorage.token}';

    var supplierData = {
      "fields": {
        "supplierName": {"stringValue": supplier.supplierName},
        "supplierDescription": {"stringValue": supplier.supplierDescription},
        "supplierRut": {"stringValue": supplier.supplierRut},
        "supplierAddress": {"stringValue": supplier.supplierAddress},
        "supplierPhone": {"stringValue": supplier.supplierPhone},
        "supplierEmail": {"stringValue": supplier.supplierEmail},
      }
    };

    final response = 
    await http.post(url, body: json.encode(supplierData), headers: {
      'authorization': basicAuth,
      'Content-type': 'application/json; charset=UTF-8',
    });

    final supplierMap = Supplier.fromMap(json.decode(response.body)['fields'], json.decode(response.body)['name']);
    
    suppliers.add(supplierMap);
    return '';
  }

  Future deleteSupplier(Supplier supplier, BuildContext context) async {
    final url = Uri.https(
      _baseUrl,
      '${_baseEndpoint}suppliers/${supplier.id}',
    );

    String basicAuth = 'Bearer ${TokenStorage.token}';

    await http.delete(url, headers: {
      'authorization': basicAuth,
      'Content-type': 'application/json; charset=UTF-8',
    });

    suppliers.clear();
    loadSuppliers();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    return '';
  }
}
