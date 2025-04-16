import 'package:flutter/material.dart';
import 'package:test_app/router/router.dart';
import 'package:test_app/widgets/navigate_button.dart';
import 'package:test_app/widgets/scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  ScaffoldWidget(
      title: 'Home Screen',
      body: Column(
        children: [
          NavigateButton(
            route: Routes.localAuth,
          ),
        ],
      ),
    );
  }
}

