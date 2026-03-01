import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/analytics_service.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/sportoto_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/screens/leagues_screen.dart';
import '../../presentation/screens/league_overview_screen.dart';
import '../../presentation/screens/team_profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// FutbolAI router — go_router + bottom navigation shell
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  observers: [AnalyticsService.observer],
  routes: [
    GoRoute(
      path: '/splash',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),

    // Full-screen routes (outside shell)
    GoRoute(
      path: '/team/:slug',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => TeamProfileScreen(
        teamSlug: state.pathParameters['slug']!,
      ),
    ),
    GoRoute(
      path: '/league/:key',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => LeagueOverviewScreen(
        leagueKey: state.pathParameters['key']!,
      ),
    ),

    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/leagues',
          builder: (context, state) => const LeaguesScreen(),
        ),
        GoRoute(
          path: '/sportoto',
          builder: (context, state) => const SportotoScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Sayfa bulunamadı',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.home_rounded),
            label: const Text('Ana Sayfaya Dön'),
          ),
        ],
      ),
    ),
  ),
);

/// Bottom Navigation Shell — updated with Leagues tab
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({required this.child, super.key});

  static const _tabs = ['/home', '/leagues', '/sportoto', '/settings'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _tabs.indexWhere((t) => location.startsWith(t));
    return index >= 0 ? index : 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => context.go(_tabs[index]),
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Ligler',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Spor Toto',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}
