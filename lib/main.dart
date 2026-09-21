import 'package:flutter/material.dart';

import 'features/catalogo/presentation/catalogo_page.dart';

void main() => runApp(const TrunoCrazyApp());

class TrunoCrazyApp extends StatelessWidget {
  const TrunoCrazyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrunoCrazy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C1906)),
        useMaterial3: true,
      ),
      home: const CatalogoPage(),
    );
  }
}
