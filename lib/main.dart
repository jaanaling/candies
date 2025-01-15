import 'package:candies/src/core/dependency_injection.dart';
import 'package:candies/src/feature/app/presentation/app_root.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencyInjection();


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const AppRoot(),
  );
}
