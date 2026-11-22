import 'package:hive_flutter/hive_flutter.dart';
import '../../shared/models/lunora_state.dart';

class LunoraStore {
  static const String _boxName = 'lunora';
  static const String _key = 'state_v1';

  static Box? _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  static LunoraState load() {
    final box = _box;
    if (box == null) return LunoraState.empty();
    final raw = box.get(_key);
    if (raw is Map) {
      try {
        return LunoraState.fromMap(Map<dynamic, dynamic>.from(raw));
      } catch (_) {
        return LunoraState.empty();
      }
    }
    return LunoraState.empty();
  }

  static Future<void> save(LunoraState state) async {
    final box = _box;
    if (box == null) return;
    await box.put(_key, state.toMap());
  }

  static Future<void> clear() async {
    final box = _box;
    if (box == null) return;
    await box.clear();
  }
}
