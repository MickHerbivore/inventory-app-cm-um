import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/models/models.dart';
import 'package:inventory_app/services/auth_service.dart';

class CategoryService extends ChangeNotifier {
  final String _baseUrl = 'firestore.googleapis.com';
  final String _baseEndpoint = '/v1/projects/back-cm-um/databases/(default)/documents/';

  List<Categoria> categories = [];
  Categoria? selectedCategory;
  bool isLoading = true;
  bool isEditCreate = true;

  CategoryService() {
    loadCategories();
  }
  
  Future loadCategories() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(
      _baseUrl,
      '${_baseEndpoint}categories/',
    );

    String basicAuth = 'Bearer ${TokenStorage.token}';
    final response = await http.get(url, headers: {'Authorization': basicAuth});
    final categoriesMap = CategoriaList.fromMap(json.decode(response.body));
    categories = categoriesMap.listado;
    isLoading = false;
    notifyListeners();
  }

  Future editOrCreateCategory(Categoria category) async {
    isEditCreate = true;
    notifyListeners();
    if (category.id.isEmpty) { 
      await createCategory(category);
    } else {
      await updateCategory(category);
    }

    isEditCreate = false;
    loadCategories();
    notifyListeners();
  }

  Future<String> updateCategory(Categoria category) async {
     final url = Uri.https(
      _baseUrl,
      '${_baseEndpoint}categories/${category.id}',
    );

    String basicAuth = 'Bearer ${TokenStorage.token}';

    var categoryData = {
      "fields": {
        "categoryName": {"stringValue": category.categoryName},
        "categoryDescription": {"stringValue": category.categoryDescription},
      }
    };

    await http.patch(url, body: json.encode(categoryData), headers: {
      'authorization': basicAuth,
      'Content-Type': 'application/json; charset=UTF-8',
    });

    final index = categories
        .indexWhere((element) => element.id == category.id);
    categories[index] = category;

    return '';
  }

  Future createCategory(Categoria category) async {
    final url = Uri.https(
      _baseUrl,
      '${_baseEndpoint}categories/',
    );

    String basicAuth = 'Bearer ${TokenStorage.token}';

    var categoryData = {
      "fields": {
        "categoryName": {"stringValue": category.categoryName},
        "categoryDescription": {"stringValue": category.categoryDescription},
      }
    };

    final response = 
    await http.post(url, body: json.encode(categoryData), headers: {
      'authorization': basicAuth,
      'Content-type': 'application/json; charset=UTF-8',
    });

    final categoryMap = Categoria.fromMap(json.decode(response.body)['fields'], json.decode(response.body)['name']);
    
    categories.add(categoryMap);
    return '';
  }

  Future deleteCategory(Categoria category, BuildContext context) async {
    final url = Uri.https(
      _baseUrl,
      '${_baseEndpoint}categories/${category.id}',
    );

    String basicAuth = 'Bearer ${TokenStorage.token}';
    
    await http.delete(url, headers: {
      'authorization': basicAuth,
      'Content-type': 'application/json; charset=UTF-8',
    });


    categories.clear();
    loadCategories();
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    return '';
  }
}
