import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'model/stat_model.dart';
import 'screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      var images = await Permission.photos.request();
      if (!images.isGranted) {
        print('Media permission not granted');
        openAppSettings();
        return;
      }
    } else {
      var storage = await Permission.storage.request();
      if (!storage.isGranted) {
        print('Storage permission not granted');
        openAppSettings();
        return;
      }
    }
  }

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
