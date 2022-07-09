import 'package:flutter_test/flutter_test.dart';
import 'package:local_value/local_data_container/local_data_container.dart';
import 'package:local_value/local_values/local_value_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';
import '../setups.dart';

void main() {
  const fakeFileName = 'hiIMAFakeFileName';
  const fakePath = 'fake/path/lol';
  const fakeBuiltPath = '$fakePath/$fakeFileName';

  setUpAll(() {
    registerTestFallbackValues();
  });

  group('create', () {
    for (DocumentType documentType in DocumentType.values) {
      test(
          'should construct sharedPrefDataContainer on isWeb with ${documentType.name}',
          () async {
        final mockLocalDataContainerDi = MockLocalDataContainerDi();
        when(() => mockLocalDataContainerDi.buildSharedPrefDataContainer(
            fakeFileName)).thenAnswer((_) async => MockLocalDataContainer());
        when(() => mockLocalDataContainerDi.isWeb).thenAnswer((_) => true);

        await LocalDataContainer.create(
            documentType, fakeFileName, mockLocalDataContainerDi);

        verify(() => mockLocalDataContainerDi
            .buildSharedPrefDataContainer(fakeFileName)).called(1);
      });
    }

    test('should call applicationDocumentDirectory on DocumentType.document',
        () async {
      final mockLocalDataContainerDi = MockLocalDataContainerDi();
      final mockDirectory = MockDirectory();

      when(() => mockLocalDataContainerDi.diGetApplicationDocumentsDirectory())
          .thenAnswer((_) async => mockDirectory);
      when(() => mockDirectory.path).thenAnswer((_) => fakePath);
      when(() => mockLocalDataContainerDi.isWeb).thenAnswer((_) => false);
      when(() => mockLocalDataContainerDi
              .buildFileDataContainer('$fakePath/$fakeFileName'))
          .thenAnswer((_) async => MockFileDataContainer());

      await LocalDataContainer.create(
          DocumentType.document, fakeFileName, mockLocalDataContainerDi);

      verify(() =>
              mockLocalDataContainerDi.diGetApplicationDocumentsDirectory())
          .called(1);

      verify(() =>
              mockLocalDataContainerDi.buildFileDataContainer(fakeBuiltPath))
          .called(1);
    });

    test('should call getApplicationSupportDirectory on DocumentType.support',
        () async {
      final mockLocalDataContainerDi = MockLocalDataContainerDi();
      final mockDirectory = MockDirectory();

      when(() => mockLocalDataContainerDi.diGetApplicationSupportDirectory())
          .thenAnswer((_) async => mockDirectory);
      when(() => mockDirectory.path).thenAnswer((_) => fakePath);
      when(() => mockLocalDataContainerDi.isWeb).thenAnswer((_) => false);
      when(() => mockLocalDataContainerDi
              .buildFileDataContainer('$fakePath/$fakeFileName'))
          .thenAnswer((_) async => MockFileDataContainer());

      await LocalDataContainer.create(
          DocumentType.support, fakeFileName, mockLocalDataContainerDi);

      verify(() => mockLocalDataContainerDi.diGetApplicationSupportDirectory())
          .called(1);

      verify(() =>
              mockLocalDataContainerDi.buildFileDataContainer(fakeBuiltPath))
          .called(1);
    });

    test(
        'should call getApplicationTemporaryDirectory on DocumentType.temporary',
        () async {
      final mockLocalDataContainerDi = MockLocalDataContainerDi();
      final mockDirectory = MockDirectory();

      when(() => mockLocalDataContainerDi.diGetTemporaryDirectory())
          .thenAnswer((_) async => mockDirectory);
      when(() => mockDirectory.path).thenAnswer((_) => fakePath);
      when(() => mockLocalDataContainerDi.isWeb).thenAnswer((_) => false);
      when(() => mockLocalDataContainerDi
              .buildFileDataContainer('$fakePath/$fakeFileName'))
          .thenAnswer((_) async => MockFileDataContainer());

      await LocalDataContainer.create(
          DocumentType.temporary, fakeFileName, mockLocalDataContainerDi);

      verify(() => mockLocalDataContainerDi.diGetTemporaryDirectory())
          .called(1);

      verify(() =>
              mockLocalDataContainerDi.buildFileDataContainer(fakeBuiltPath))
          .called(1);
    });

    test('should call buildSharedPrefDataContainer on DocumentType.prefs',
        () async {
      final mockLocalDataContainerDi = MockLocalDataContainerDi();

      when(() => mockLocalDataContainerDi.buildSharedPrefDataContainer(
          fakeFileName)).thenAnswer((_) async => MockFileDataContainer());
      when(() => mockLocalDataContainerDi.isWeb).thenAnswer((_) => false);

      await LocalDataContainer.create(
          DocumentType.prefs, fakeFileName, mockLocalDataContainerDi);

      verify(() => mockLocalDataContainerDi
          .buildSharedPrefDataContainer(fakeFileName)).called(1);
    });
  });
}
