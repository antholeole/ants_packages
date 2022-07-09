part of 'local_data_container.dart';

/// allows dependency injection into LocalDataContainer.
class LocalDataContainerDi {
  bool get isWeb => kIsWeb;

  Future<Directory> diGetApplicationDocumentsDirectory() {
    return getApplicationDocumentsDirectory();
  }

  Future<Directory> diGetApplicationSupportDirectory() {
    return getApplicationSupportDirectory();
  }

  Future<Directory> diGetTemporaryDirectory() {
    return getTemporaryDirectory();
  }

  Future<LocalDataContainer> buildSharedPrefDataContainer(String fileName) {
    return SharedPrefDataContainer.build(fileName);
  }

  Future<FileDataContainer> buildFileDataContainer(String fileName) async {
    return FileDataContainer(fileName);
  }

  Future<LocalDataContainer> diGetSecureDataContainer(String fileName) async {
    return SecureDataContainer(fileName);
  }
}
