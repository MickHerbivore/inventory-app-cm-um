import 'package:flutter/material.dart';
import 'package:inventory_app/models/supplier.dart';

class SupplierFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Supplier supplier;
  SupplierFormProvider(this.supplier);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
