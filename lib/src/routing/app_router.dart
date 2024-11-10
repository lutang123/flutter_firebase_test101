import 'package:faker_app_flutter_firebase/src/routing/go_router_refresh_stream.dart';
import 'package:faker_app_flutter_firebase/src/screens/custom_profile_screen.dart';
import 'package:faker_app_flutter_firebase/src/screens/custom_sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as firebase_ui_auth;

enum AppRoute {
  signIn,
  profile,
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);

  return GoRouter(
    initialLocation: '/sign-in',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // FirebaseAuth.instance singleton should be avoided
      final isLoggedIn = firebaseAuth.currentUser != null;
      if (isLoggedIn) {
        if (state.uri.path == '/sign-in') {
          return AppRoute.profile.name; //'/prifile'
        }
      } else {
        if (state.uri.path == '/profile') {
          return AppRoute.signIn.name; //'/sign-in'
        }
      }
      //if we return null if we don't want to redirect
      return null;
    },
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    routes: [
      GoRoute(
        path: '/sign-in',
        name: AppRoute.signIn.name,
        builder: (context, state) => const CustomSignInScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoute.profile.name,
        builder: (context, state) => const CustomProfileScreen(),
      ),
    ],
  );
});

final authProvidersProvider =
    Provider<List<firebase_ui_auth.AuthProvider>>((ref) {
  return [firebase_ui_auth.EmailAuthProvider()];
});
