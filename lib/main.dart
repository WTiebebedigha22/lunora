import 'package:flutter/material.dart';
import 'core/storage/lunora_store.dart';
import 'lunora_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LunoraStore.init();
  runApp(const LunoraApp());
}
