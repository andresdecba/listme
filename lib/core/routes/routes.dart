import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/crud/ui/home_screen/home_screen.dart';
import 'package:listme/crud/ui/crud_screen/new_crud_screen.dart';

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
        //builder: (context, state) => const Booorar(),
      ),

      GoRoute(
          path: '/crudScreen',
          name: crudScreen,
          builder: (context, state) {
            String extra = state.extra as String;
            return NewCrudScreen(id: extra);
          }),
    ],
  );
}
