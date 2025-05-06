import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'model/stat_model.dart';
import 'screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final docDir = await getApplicationDocumentsDirectory();
  final isarInstance = await Isar.open([
    StatModelSchema,
  ], directory: docDir.path);

  GetIt.I.registerSingleton<Isar>(isarInstance);

  runApp(const DustifyApp());
}

class DustifyApp extends StatelessWidget {
  const DustifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'SF Pro Display'),
      home: const HomeScreen(),
    );
  }
}
