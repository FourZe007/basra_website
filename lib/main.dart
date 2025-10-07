import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoadingModel()),
        ChangeNotifierProvider(create: (_) => UserIDmodel()),
        ChangeNotifierProvider(create: (_) => PtModel()),
        ChangeNotifierProvider(create: (_) => MenuState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouterSettings.router,
      debugShowCheckedModeBanner: false,
      title: 'SIP',
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      theme: ThemeData(
          useMaterial3: true,
          iconTheme: IconThemeData(color: Colors.black),
          colorSchemeSeed: const Color(0xFF8EACCD),
          cardColor: Color.fromARGB(159, 210, 224, 251),
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Color.fromARGB(255, 231, 230, 230)),
    );
  }
}
