import 'package:candies/src/feature/rituals/model/recipe.dart';
import 'package:candies/src/feature/rituals/presentation/home_screen.dart';
import 'package:candies/src/feature/rituals/presentation/recipe_screen.dart';
import 'package:candies/src/feature/rituals/presentation/shop_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../src/feature/splash/presentation/screens/splash_screen.dart';
import 'root_navigation_screen.dart';
import 'route_value.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();

final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildGoRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteValue.splash.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) {
        return NoTransitionPage(
          child: RootNavigationScreen(
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
                path: RouteValue.home.path,
                builder: (BuildContext context, GoRouterState state) {
                  return const HomeScreen();
                },
                routes: [
                  GoRoute(
                    path: RouteValue.recipe.path,
                    builder: (BuildContext context, GoRouterState state) {
                      return RecipeScreen(
                        recipe: state.extra as Recipe,
                      );
                    },
                  ),
                  GoRoute(
                    path: RouteValue.shop.path,
                    builder: (BuildContext context, GoRouterState state) {
                      return const ShopScreen();
                    },
                  ),
                ]),
          ],
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.black,
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteValue.splash.path,
          builder: (BuildContext context, GoRouterState state) {
            return const SplashScreen();
          },
        ),
      ],
    ),
  ],
);
