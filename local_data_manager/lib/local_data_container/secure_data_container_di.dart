part of 'package:local_value/local_data_container/secure_data_container.dart';

SecureDataContainer buildSecureStorageDataContainerWithDependencies(
    String path, FlutterSecureStorage secureStorage) {
  return SecureDataContainer._withDependencies(path,
      secureStorage: secureStorage);
}
