part of 'file_data_container.dart';

FileDataContainer buildFileDataContainerWithDependencies(
    String path, File Function(String) makeFile) {
  return FileDataContainer._withDependencies(path, makeFile);
}
