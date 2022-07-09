import 'package:flutter_test/flutter_test.dart';
import 'package:local_value/local_values/local_singleton.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';
import '../setups.dart';
import '../test_helpers.dart';

void main() {
  const fakeFileName = 'MOCK_FILE_NAME';

  setUpAll(() {
    registerTestFallbackValues();
  });

  test('should read value from fileName passed in constructor', () async {
    final mockLocalDataContainerCreator = MockLocalDataContainerCreator();
    when(() => mockLocalDataContainerCreator.getContainer(any(), any()))
        .thenAnswer((_) async => MockLocalDataContainer());

    final localSingleton = buildLocalSingleWithDependences<String>(
      fileName: fakeFileName,
      localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
    );
    await localSingleton.read();

    expect(
        verify(() =>
                mockLocalDataContainerCreator.getContainer(any(), captureAny()))
            .captured[0],
        withFileExtension(fakeFileName));
  });

  test('should call localDataContainer.read on read', () async {
    final MockLocalDataContainer mockLocalDataContainer =
        MockLocalDataContainer();
    final mockLocalDataContainerCreator = MockLocalDataContainerCreator();
    when(() => mockLocalDataContainerCreator.getContainer(any(), any()))
        .thenAnswer((_) async => mockLocalDataContainer);

    when(() => mockLocalDataContainer.read()).thenAnswer((_) async => null);

    final localSingleton = buildLocalSingleWithDependences<String>(
      fileName: fakeFileName,
      localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
    );
    await localSingleton.read();

    verify(() => mockLocalDataContainer.read()).called(1);
  });

  test('should call localDataContainer.write on write', () async {
    const writeObj = 'aoskdaoskdoaskd';

    final MockLocalDataContainer mockLocalDataContainer =
        MockLocalDataContainer();
    final mockLocalDataContainerCreator = MockLocalDataContainerCreator();
    when(() => mockLocalDataContainerCreator.getContainer(any(), any()))
        .thenAnswer((_) async => mockLocalDataContainer);

    when(() => mockLocalDataContainer.write(writeObj))
        .thenAnswer((_) async => {});

    final localSingleton = buildLocalSingleWithDependences<String>(
      fileName: fakeFileName,
      localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
    );
    await localSingleton.write(writeObj);

    expect(
        verify(() => mockLocalDataContainer.write(captureAny())).captured[0]
            as String,
        contains(writeObj));
  });

  test('should call localDataContainer.delete on delete', () async {
    final MockLocalDataContainer mockLocalDataContainer =
        MockLocalDataContainer();
    final mockLocalDataContainerCreator = MockLocalDataContainerCreator();
    when(() => mockLocalDataContainerCreator.getContainer(any(), any()))
        .thenAnswer((_) async => mockLocalDataContainer);

    when(() => mockLocalDataContainer.delete()).thenAnswer((_) async => true);

    final localSingleton = buildLocalSingleWithDependences<String>(
      fileName: fakeFileName,
      localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
    );
    await localSingleton.delete();

    verify(() => mockLocalDataContainer.delete()).called(1);
  });
}
