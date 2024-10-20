import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool isLoading = false;
  bool errorLogin = false;

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void setErrorLogin(bool value) {
    errorLogin = value;
    notifyListeners();
  }
}