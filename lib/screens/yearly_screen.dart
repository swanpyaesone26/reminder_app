import 'package:flutter/material.dart';

class YearlyScreen extends StatelessWidget {
  const YearlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yearly')),
      body: const Center(child: Text('Yearly Screen')),
    );
  }
}