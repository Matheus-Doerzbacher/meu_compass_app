import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_compass_app/data/repositories/auth/auth_repository.dart';
import 'package:meu_compass_app/routing/routes.dart';
import 'package:meu_compass_app/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:meu_compass_app/ui/auth/login/widgets/login_screen.dart';
import 'package:provider/provider.dart';

GoRouter router(
  AuthRepository authRepository,
) =>
    GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      redirect: _redirect,
      refreshListenable: authRepository,
      routes: [
        GoRoute(
          path: Routes.login,
          builder: (context, state) {
            return LoginScreen(
              viewModel: LoginViewModel(
                authRepository: context.read(),
              ),
            );
          },
        ),
        // GoRoute(
        //   path: Routes.home,
        //   builder: (context, state) {
        //     final viewModel = HomeViewModel(
        //       bookingRepository: context.read(),
        //       userRepository: context.read(),
        //     );
        //     return HomeScreen(viewModel: viewModel);
        //   },
        // )
      ],
    );

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;

  if (!loggedIn) {
    return Routes.login;
  }

  if (loggingIn) {
    return Routes.home;
  }

  return null;
}
