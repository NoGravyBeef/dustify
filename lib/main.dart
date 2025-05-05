import 'package:dustify/model/stat_model.dart';
import 'package:dustify/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([StatModelSchema], directory: dir.path);

  GetIt.I.registerSingleton<Isar>(isar);

  runApp(
    MaterialApp(theme: ThemeData(fontFamily: 'sunflower'), home: HomeScreen()),
  );
}
