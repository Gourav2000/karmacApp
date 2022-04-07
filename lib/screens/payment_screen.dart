import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Coming Soon',
        style: TextStyle(
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
