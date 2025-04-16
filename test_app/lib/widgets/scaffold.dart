import 'package:flutter/material.dart';

class ScaffoldWidget extends StatelessWidget {
  const ScaffoldWidget({
    required this.title,
    required this.body,
    super.key,
    });
  final String title;
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: body,
      ),
    );
  }
}