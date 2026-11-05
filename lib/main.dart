import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:im_relawan/firebase_options.dart';
import 'package:im_relawan/routing/app_router.dart';
import 'package:im_relawan/ui/core/themes/app_theme.dart';
import 'package:im_relawan/ui/core/themes/util.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(
      context,
      "Inter",
      "Montserrat",
    );

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'Im Relawan',
      theme: theme.light(),
      routerConfig: router,
      // showSemanticsDebugger: true,
    );
  }
}