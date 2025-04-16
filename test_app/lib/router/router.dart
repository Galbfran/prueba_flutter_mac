import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/pages/home.dart';
import 'package:test_app/pages/local_auth.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'local_auth',
          builder: (BuildContext context, GoRouterState state) {
            return const LocalAuthScreen();
          },
        ),
      ],
    ),
  ],
);