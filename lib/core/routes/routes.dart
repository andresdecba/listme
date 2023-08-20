import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/borrar/tabview_Example.dart';
import 'package:listme/crud/ui/home_screen/home_screen.dart';
import 'package:listme/crud/ui/crud_screen/crud_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static const homeScreen = 'homeScreen';
  static const crudScreen = 'crudScreen';
  static const tabScreen = 'tabScreen';

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
        path: '/tabScreen',
        name: tabScreen,
        builder: (context, state) => const TabviewExample(),
      ),

      GoRoute(
          path: '/crudScreen',
          name: crudScreen,
          builder: (context, state) {
            String extra = state.extra as String;
            return CrudScreen(id: extra);
          }),
    ],
  );
}
