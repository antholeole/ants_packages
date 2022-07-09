import 'package:local_value/local_data_container/local_data_container.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'secure_data_container_di.dart';

class SecureDataContainer extends LocalDataContainer {
  final String _key;
  final FlutterSecureStorage _secureStorage;

  SecureDataContainer(String key)
      : _key = key,
        _secureStorage = const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true));

  SecureDataContainer._withDependencies(String key,
      {FlutterSecureStorage? secureStorage})
      : _key = key,
        _secureStorage = secureStorage ??
            const FlutterSecureStorage(
                aOptions: AndroidOptions(encryptedSharedPreferences: true));

  @override
  Future<bool> delete() async {
    if (await _secureStorage.containsKey(key: _key)) {
      await _secureStorage.delete(key: _key);
      return true;
    }

    return false;
  }

  @override
  Future<bool> exists() {
    return _secureStorage.containsKey(key: _key);
  }

  @override
  Future<String?> read() async {
    if (await _secureStorage.containsKey(key: _key)) {
      return await _secureStorage.read(key: _key);
    }

    return null;
  }

  @override
  Future<void> write(String objEncoding) {
    return _secureStorage.write(key: _key, value: objEncoding);
  }
}
