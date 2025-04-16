import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/pages/home.dart';
import 'package:test_app/pages/local_auth.dart';

class Routes{
  static const String home = '/';
  static const String localAuth = '/local_auth';
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: Routes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: Routes.localAuth,
          builder: (BuildContext context, GoRouterState state) {
            return const LocalAuthScreen();
          },
        ),
      ],
    ),
  ],
);