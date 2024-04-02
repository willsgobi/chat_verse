import 'package:chat_verse/src/core/providers/i_storage_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider implements IStorageProvider {
  @override
  Future<bool> hasKey(String key) async {
    final sharedPrefs = await SharedPreferences.getInstance();

    return sharedPrefs.containsKey(key);
  }

  @override
  Future<String?> get(String key) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final storageData = sharedPrefs.get(key);
    return storageData == null ? null : storageData as String;
  }

  @override
  Future<List<String>?> getList(String key) async {
    final sharedPrefs = await SharedPreferences.getInstance();

    return sharedPrefs.getStringList(key);
  }

  @override
  Future set(String key, String value) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(key, value);
  }

  @override
  Future<bool> setList(String key, List<String> value) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final added = await sharedPrefs.setStringList(key, value);
    return added;
  }

  @override
  Future delete(String key) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.remove(key);
  }

  @override
  Future deleteAllData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.clear();
  }
}
