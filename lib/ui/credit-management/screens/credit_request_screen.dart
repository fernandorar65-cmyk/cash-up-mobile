import 'package:flutter/material.dart';

class CreditRequestScreen extends StatelessWidget {
  const CreditRequestScreen({super.key});

  static const routeName = 'credit_request';
  static const routePath = '/credit-request';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Credit Request Screen'),
      ),
    );
  }
}