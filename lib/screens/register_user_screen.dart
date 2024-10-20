import 'package:flutter/material.dart';
import 'package:inventory_app/services/auth_service.dart';
import 'package:inventory_app/theme/my_theme.dart';
import 'package:inventory_app/ui/input_decorations.dart';
import 'package:inventory_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/login_form_provider.dart';

class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              CardContainer(
                  child: Column(
                    children: [
                      const Padding(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                      child: Text(
                        'Registro a Inventory App',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const RegisterForm(),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                        overlayColor: WidgetStateProperty.all(MyTheme.secondary.withOpacity(0.1)),
                        shape: WidgetStateProperty.all(const StadiumBorder())
                      ),
                      child: const Text(
                        '¿Ya tienes una cuenta?, autentificate',
                        style: TextStyle(color: MyTheme.primary),
                      ),
                    )
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        TextFormField(
          autocorrect: false,
          keyboardType: TextInputType.text,
          decoration: InputDecorations.authInputDecoration(
            hinText: 'Ingrese su correo',
            labelText: 'Email',
            prefixIcon: Icons.people,
          ),
          onChanged: (value) => loginForm.email = value,
          validator: (value) {
            return (value != null && value.length >= 4)
                ? null
                : 'El usuario no puede estar vacio';
          },
        ),
        const SizedBox(height: 30),
        TextFormField(
          autocorrect: false,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecorations.authInputDecoration(
            hinText: '************',
            labelText: 'Password',
            prefixIcon: Icons.lock_outline,
          ),
          onChanged: (value) => loginForm.password = value,
          validator: (value) {
            return (value != null && value.length >= 4)
                ? null
                : 'La contraseña no puede estar vacio';
          },
        ),
        const SizedBox(height: 30),
        TextFormField(
          autocorrect: false,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecorations.authInputDecoration(
            hinText: '************',
            labelText: 'Repite el Password',
            prefixIcon: Icons.lock_outline,
          ),
          validator: (value) {
            return (value != null && value.length >= 4 && value == loginForm.password)
                ? null
                : 'Las contraseñas no coinciden o son inválidas';
          },
        ),
        const SizedBox(height: 30),
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          disabledColor: Colors.grey,
          color: MyTheme.primary,
          elevation: 0,
          onPressed: loginForm.isLoading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  if (!loginForm.isValidForm()) return;
                  loginForm.isLoading = true;
                  final String? errorMessage = await authService.createUser(
                      loginForm.email, loginForm.password);
                  if (errorMessage == null) {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  } else {
                    print(errorMessage);
                  }
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            child: const Text(
              'Registrar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ]),
    );
  }
}
