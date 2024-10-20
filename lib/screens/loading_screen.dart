import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage('assets/loading.gif'),
        ),
      ),
    );
  }
}