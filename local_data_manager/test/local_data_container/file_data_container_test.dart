import 'package:flutter_test/flutter_test.dart';
import 'package:local_value/local_data_container/file_data_container.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  const fakePath = 'hitherealligator';

  test('should build file with passed in name', () {
    final mockCaller = MockCaller();

    buildFileDataContainerWithDependencies(fakePath, (fileName) {
      mockCaller.call();
      expect(fileName, fakePath);
      return MockFile();
    });

    verify(() => mockCaller.call()).called(1);
  });

  test('exists should call file.exists and return result', () async {
    const existsResult = true;
    final fakeFile = MockFile();

    when(() => fakeFile.exists()).thenAnswer((_) async => existsResult);

    final fileDataContainer =
        buildFileDataContainerWithDependencies(fakePath, (_) => fakeFile);

    expect(await fileDataContainer.exists(), existsResult);
  });

  group('delete', () {
    test('should delete if exists', () async {
      final fakeFile = MockFile();

      when(() => fakeFile.exists()).thenAnswer((_) async => true);
      when(() => fakeFile.delete())
          .thenAnswer((_) async => FakeFileSystemEntity());

      final fileDataContainer =
          buildFileDataContainerWithDependencies(fakePath, (_) => fakeFile);

      expect(await fileDataContainer.delete(), true);
      verify(() => fakeFile.delete()).called(1);
    });

    test('should not delete if not exists', () async {
      final fakeFile = MockFile();

      when(() => fakeFile.exists()).thenAnswer((_) async => false);
      when(() => fakeFile.delete())
          .thenAnswer((_) async => FakeFileSystemEntity());

      final fileDataContainer =
          buildFileDataContainerWithDependencies(fakePath, (_) => fakeFile);

      expect(await fileDataContainer.delete(), false);
      verifyNever(() => fakeFile.delete());
    });
  });

  group('read', () {
    test('should read if exists', () async {
      const fakeResult = 'Hi Im read as string';
      final fakeFile = MockFile();

      when(() => fakeFile.exists()).thenAnswer((_) async => true);
      when(() => fakeFile.readAsString()).thenAnswer((_) async => fakeResult);

      final fileDataContainer =
          buildFileDataContainerWithDependencies(fakePath, (_) => fakeFile);

      expect(await fileDataContainer.read(), fakeResult);
    });

    test('should return null if not exists and return null', () async {
      const fakeResult = 'Hi Im read as string';
      final fakeFile = MockFile();

      when(() => fakeFile.exists()).thenAnswer((_) async => false);
      when(() => fakeFile.readAsString()).thenAnswer((_) async => fakeResult);

      final fileDataContainer =
          buildFileDataContainerWithDependencies(fakePath, (_) => fakeFile);

      expect(await fileDataContainer.read(), null);
      verifyNever(() => fakeFile.readAsString());
    });
  });

  group('write', () {
    test('should create then write on file that does not exist', () async {
      const fakeResult = 'Hi Im write as string';
      final fakeFile = MockFile();

      when(() => fakeFile.exists()).thenAnswer((_) async => false);
      when(() => fakeFile.create(recursive: true))
          .thenAnswer((_) async => fakeFile);
      when(() => fakeFile.writeAsString(fakeResult))
          .thenAnswer((_) async => fakeFile);

      final fileDataContainer =
          buildFileDataContainerWithDependencies(fakePath, (_) => fakeFile);
      await fileDataContainer.write(fakeResult);

      verify(() => fakeFile.writeAsString(fakeResult)).called(1);
      verify(() => fakeFile.create(recursive: true)).called(1);
    });

    test('should write on write that exists', () async {
      const fakeResult = 'Hi Im write as string';
      final fakeFile = MockFile();

      when(() => fakeFile.exists()).thenAnswer((_) async => true);

      when(() => fakeFile.writeAsString(fakeResult))
          .thenAnswer((_) async => fakeFile);

      final fileDataContainer =
          buildFileDataContainerWithDependencies(fakePath, (_) => fakeFile);
      await fileDataContainer.write(fakeResult);

      verify(() => fakeFile.writeAsString(fakeResult)).called(1);
      verifyNever(() => fakeFile.create(recursive: any(named: 'recursive')));
    });
  });
}
