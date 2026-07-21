import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/auth_choice_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/booking/services_screen.dart';
import '../screens/booking/service_detail_screen.dart';
import '../screens/booking/category_services_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking/confirmation_screen.dart';
import '../screens/courses/courses_screen.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/home/home_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authService.isAuthenticated;
      final location = state.matchedLocation;
      final isProtectedRoute = location.startsWith('/home') ||
          location.startsWith('/services') ||
          location.startsWith('/courses') ||
          location.startsWith('/profile');

      if (!isAuthenticated && isProtectedRoute) {
        return '/auth-choice';
      }

      if (isAuthenticated && location == '/auth-choice') {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth-choice',
        builder: (_, __) => const AuthChoiceScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __, navigationShell) => HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/services',
                builder: (_, __) => const ServicesScreen(),
                routes: [
                  GoRoute(
                    path: 'category/:name',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, state) => CategoryServicesScreen(
                      categoryName: state.pathParameters['name']!,
                    ),
                  ),
                  GoRoute(
                    path: 'detail/:id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, state) => ServiceDetailScreen(
                      serviceId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'book',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, state) => BookingScreen(
                      serviceId: state.uri.queryParameters['service'],
                    ),
                  ),
                  GoRoute(
                    path: 'confirm',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, __) => const ConfirmationScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/courses',
                builder: (_, __) => const CoursesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, __) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'journey',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, __) => const JourneyScreen(),
                  ),
                  GoRoute(
                    path: 'history',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (_, __) => const HistoryScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
