import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 50),
                child: const Icon(
                  Icons.inventory_outlined,
                  color: Colors.white,
                  size: 100,
                ),
              )
            ),
            child,
          ]
        ),
      ),
    );
  }
}
