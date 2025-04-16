import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigateButton extends StatelessWidget {
  const NavigateButton({
    required this.route,
    super.key,
  });
  final String route ;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.go(route),
      title: Text(route),

      trailing: Icon(Icons.arrow_forward_ios),
      );
  }
}
