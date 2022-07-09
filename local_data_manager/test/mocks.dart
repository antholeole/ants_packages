import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_value/local_data_container/local_data_container.dart';
import 'package:local_value/local_values/local_value_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_value/local_data_container/file_data_container.dart';

class MockLocalDataContainerCreator extends Mock {
  Future<LocalDataContainer> getContainer(
      DocumentType documentType, String string);
}

class MockLocalDataContainer extends Mock implements LocalDataContainer {}

class MockSharedPreference extends Mock implements SharedPreferences {}

class MockFile extends Mock implements File {}

class MockDirectory extends Mock implements Directory {}

class MockFileDataContainer extends Mock implements FileDataContainer {}

class FakeFileSystemEntity extends Fake implements FileSystemEntity {}

class MockLocalDataContainerDi extends Mock implements LocalDataContainerDi {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class Caller {
  void call() {}
}

class MockCaller extends Mock implements Caller {}

class FakeObject {
  static String propertyKey = 'propertyKey';

  final int fakeProperty;

  const FakeObject({required this.fakeProperty});

  static FakeObject fromJson(Map<String, dynamic> json) =>
      FakeObject(fakeProperty: json[propertyKey]);
  Map<String, dynamic> toJson() => {propertyKey: fakeProperty};
}
