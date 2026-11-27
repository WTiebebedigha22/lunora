import 'package:material_ui/material_ui.dart';
import 'core/storage/lunora_store.dart';
import 'core/notifications/lunora_notifications.dart';
import 'lunora_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LunoraStore.init();
  await LunoraNotifications.initialize();
  runApp(const LunoraApp());
}
