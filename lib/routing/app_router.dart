import 'package:go_router/go_router.dart';
import 'package:im_relawan/domain/models/bencana_list.dart';
import 'package:im_relawan/ui/bencana/widgets/daftar_bencana_screen.dart';
import 'package:im_relawan/ui/bencana/widgets/form_bencana_screen.dart';
import 'package:im_relawan/ui/core/ui/splash_screen.dart';
import 'package:im_relawan/ui/detail_bencana/widgets/detail_bencana_screen.dart';
import 'package:im_relawan/ui/bencana/widgets/edit_bencana_screen.dart';

final router = GoRouter(
  initialLocation: '/splash-screen',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => DaftarBencanaScreen(),
      routes: [
        GoRoute(
          name: 'detail',
          path: 'detail/:id',
          builder: (context, state) =>
              DetailBencanaScreen(id: state.pathParameters['id']!),
        ), // GoRoute (detail)
        GoRoute(
          path: 'form',
          name: 'tambah',
          builder: (context, state) => FormBencanaScreen(),
        ), // GoRoute (form)
        GoRoute(
          path: 'edit',
          name: 'edit',
          builder: (context, state) =>
              EditBencanaScreen(bencana: state.extra as BencanaList),
        ), // GoRoute (edit)
      ],
    ), // GoRoute (home)
    GoRoute(
      name: 'splash',
      path: '/splash-screen',
      builder: (context, state) => SplashScreen(),
    ), // GoRoute (splash)
  ],
); // GoRouter
