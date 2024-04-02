abstract class IStorageProvider {
  Future<bool> hasKey(String key);
  Future<String?> get(String key);
  Future<List<String>?> getList(String key);
  Future set(String key, String value);
  Future<bool> setList(String key, List<String> value);
  Future delete(String key);
  Future deleteAllData();
}
