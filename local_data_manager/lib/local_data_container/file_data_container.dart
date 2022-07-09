import 'dart:io';

import 'package:local_value/local_data_container/local_data_container.dart';

part 'file_data_container_di.dart';

/// data container for all local file system storage.
class FileDataContainer extends LocalDataContainer {
  final File _file;

  FileDataContainer(String path) : _file = File(path);

  FileDataContainer._withDependencies(
      String path, File Function(String) makeFile)
      : _file = makeFile(path);

  @override
  Future<bool> delete() async {
    if (await _file.exists()) {
      await _file.delete();
      return true;
    }

    return false;
  }

  @override
  Future<bool> exists() {
    return _file.exists();
  }

  @override
  Future<String?> read() async {
    if (await _file.exists()) {
      return _file.readAsString();
    }

    return null;
  }

  @override
  Future<void> write(String objEncoding) async {
    if (!(await _file.exists())) {
      await _file.create(recursive: true);
    }

    await _file.writeAsString(objEncoding);
  }
}
