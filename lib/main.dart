import 'package:eplradar_mobile/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<CookieRequest>(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'EPL Radar Stats',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF1D1F22),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1D1F22),
            elevation: 0,
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
