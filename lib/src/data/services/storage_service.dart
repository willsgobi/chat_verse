import 'package:chat_verse/src/core/providers/i_storage_provider.dart';

class StorageService {
  final IStorageProvider _storageProvider;

  StorageService(this._storageProvider);

  Future setTheme(String themeName) async {
    _storageProvider.set("theme", themeName);
  }

  Future<String?> getTheme() async {
    return _storageProvider.get("theme");
  }
}
