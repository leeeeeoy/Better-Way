import 'package:better_way/feature/home/home_screen.dart';
import 'package:better_way/feature/main/main_screen.dart';
import 'package:better_way/feature/setting/setting_screen.dart';
import 'package:better_way/router/app_route_state.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) => MainScreen(navigationShell: child),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${AppRouteState.home.path}',
              name: AppRouteState.home.name,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${AppRouteState.setting.path}',
              name: AppRouteState.setting.name,
              builder: (context, state) => const SettingScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
