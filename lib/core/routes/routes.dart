import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen.dart';
import 'package:listme/crud/ui/home_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static const homeScreen = 'homeScreen';
  static const crudScreen = 'crudScreen';

  static final appRoutes = GoRouter(
    initialLocation: '/',
    navigatorKey: navigatorKey,
    routes: [
      // home
      GoRoute(
        path: '/',
        name: homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
          path: '/crudScreen',
          name: crudScreen,
          builder: (context, state) {
            Lista extra = state.extra as Lista;
            return CrudScreen(lista: extra);
          }),
    ],
  );
}
