part of 'app.dart';

final _router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: const SplashRoute().location,
  routes: [
    $splashRoute,
  ],
);
