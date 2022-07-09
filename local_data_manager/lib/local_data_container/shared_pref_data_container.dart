import 'package:shared_preferences/shared_preferences.dart';

import 'local_data_container.dart';

part 'shared_pref_data_container_di.dart';

/// data container for web and [DocumentType.prefs].
class SharedPrefDataContainer extends LocalDataContainer {
  final String _path;
  final SharedPreferences _sharedPreferences;

  SharedPrefDataContainer._(String path, SharedPreferences sharedPreferences)
      : _sharedPreferences = sharedPreferences,
        _path = path;

  static Future<SharedPrefDataContainer> build(String path) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return SharedPrefDataContainer._(path, sharedPreferences);
  }

  @override
  Future<bool> delete() {
    return _sharedPreferences.remove(_path);
  }

  @override
  bool exists() {
    return _sharedPreferences.containsKey(_path);
  }

  @override
  String? read() {
    return _sharedPreferences.getString(_path);
  }

  @override
  Future<void> write(String objEncoding) {
    return _sharedPreferences.setString(_path, objEncoding);
  }
}
