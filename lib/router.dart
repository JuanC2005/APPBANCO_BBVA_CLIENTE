import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cuentas_screen.dart';
import 'screens/cuenta_detalle_screen.dart';
import 'screens/creditos_screen.dart';
import 'screens/cronograma_screen.dart';
import 'screens/tarjetas_screen.dart';
import 'screens/transferencia_screen.dart';
import 'screens/pago_screen.dart';
import 'screens/notificaciones_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/mis_solicitudes_screen.dart';
import 'screens/nueva_solicitud_screen.dart';
import 'screens/detalle_solicitud_screen.dart';

class _GoRouterNotifier extends ChangeNotifier {
  _GoRouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;

  String? _redirectLogic(GoRouterState state) {
    final auth = _ref.read(authProvider);
    final isLoginRoute = state.matchedLocation == '/login';

    if (auth.isAuthenticated && isLoginRoute) return '/home';
    if (!auth.isAuthenticated && !isLoginRoute) return '/login';
    return null;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _GoRouterNotifier(ref);
  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) => notifier._redirectLogic(state),
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'cuentas',
            builder: (context, state) => const CuentasScreen(),
          ),
          GoRoute(
            path: 'cuentas/:id',
            builder: (context, state) => CuentaDetalleScreen(
              cuentaId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: 'creditos',
            builder: (context, state) => const CreditosScreen(),
          ),
          GoRoute(
            path: 'creditos/:id/cronograma',
            builder: (context, state) => CronogramaScreen(
              creditoId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: 'tarjetas',
            builder: (context, state) => const TarjetasScreen(),
          ),
          GoRoute(
            path: 'transferencia',
            builder: (context, state) => const TransferenciaScreen(),
          ),
          GoRoute(
            path: 'pago',
            builder: (context, state) => const PagoScreen(),
          ),
          GoRoute(
            path: 'notificaciones',
            builder: (context, state) => const NotificacionesScreen(),
          ),
          GoRoute(
            path: 'perfil',
            builder: (context, state) => const PerfilScreen(),
          ),
          GoRoute(
            path: 'mis-solicitudes',
            builder: (context, state) => const MisSolicitudesScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => DetalleSolicitudScreen(
                  solicitudId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'nueva-solicitud',
            builder: (context, state) => const NuevaSolicitudScreen(),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
