import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:local_value/local_data_container/secure_data_container.dart';
import 'package:local_value/local_data_container/shared_pref_data_container.dart';
import 'package:local_value/local_values/local_value_impl.dart';
import 'package:path_provider/path_provider.dart';

import 'file_data_container.dart';

part 'local_data_container_di.dart';

/// internal abstraction over file system storage for web.
abstract class LocalDataContainer {
  /// [fileName] is expected to already contain the path joined into a string.
  ///
  // ignore: todo
  /// TODO: this operation calls async functions every construction. Either cache this in
  /// LocalValueImpl, or somehow cache the async calls for performance.
  static Future<LocalDataContainer> create(
      DocumentType documentType, String fileName,
      [LocalDataContainerDi? localDataContainerDi]) async {
    final dataContainerDi = localDataContainerDi ?? LocalDataContainerDi();

    if (dataContainerDi.isWeb) {
      return dataContainerDi.buildSharedPrefDataContainer(fileName);
    }

    Future<Directory> dir;
    switch (documentType) {
      case DocumentType.document:
        dir = dataContainerDi.diGetApplicationDocumentsDirectory();
        break;
      case DocumentType.support:
        dir = dataContainerDi.diGetApplicationSupportDirectory();
        break;
      case DocumentType.temporary:
        dir = dataContainerDi.diGetTemporaryDirectory();
        break;
      case DocumentType.prefs:
        return dataContainerDi.buildSharedPrefDataContainer(fileName);
      case DocumentType.secure:
        return dataContainerDi.diGetSecureDataContainer(fileName);
    }

    final directory = await dir;
    return dataContainerDi
        .buildFileDataContainer('${directory.path}/$fileName');
  }

  FutureOr<bool> exists();
  FutureOr<bool> delete();
  FutureOr<String?> read();
  FutureOr<void> write(String objEncoding);
}
