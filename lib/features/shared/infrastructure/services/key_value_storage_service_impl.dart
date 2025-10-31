import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage_service.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    // Usa el value runtime type en vez de T
    final type = T.toString();

    if (type == 'int' || type == 'int?') {
      return prefs.getInt(key) as T?;
    } else if (type == 'String' || type == 'String?') {
      return prefs.getString(key) as T?;
    } else {
      throw UnimplementedError('GET not implemented for type $T');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else {
      throw UnimplementedError(
        'Set not implemented for type ${value.runtimeType}',
      );
    }
  }
}
