import 'package:flutter/material.dart';
import 'package:test_app/widgets/scaffold.dart';

class LocalAuthScreen extends StatelessWidget {
  const LocalAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldWidget(
      title: 'Local Auth Screen',
      body: Center(
        child: Text('Local Auth Screen'),
      ),
    );
  }
}