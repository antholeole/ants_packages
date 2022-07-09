import 'package:flutter_test/flutter_test.dart';
import 'package:local_value/local_data_container/secure_data_container.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  const dataPath = 'Hello';

  test('delete should call secureStorage.delete and return result', () async {
    const deleteResult = true;
    final mockSecureStorage = MockFlutterSecureStorage();

    when(() => mockSecureStorage.delete(key: dataPath))
        .thenAnswer((_) async => deleteResult);
    when(() => mockSecureStorage.containsKey(key: dataPath))
        .thenAnswer((_) async => deleteResult);

    final SecureDataContainer sharedPrefDataContainer =
        buildSecureStorageDataContainerWithDependencies(
            dataPath, mockSecureStorage);

    expect(await sharedPrefDataContainer.delete(), deleteResult);
    verify(() => mockSecureStorage.delete(key: dataPath)).called(1);
  });

  test('exists should call secureStorage.containsKey and return result',
      () async {
    const containsResult = true;
    final mockSecureStorage = MockFlutterSecureStorage();

    when(() => mockSecureStorage.containsKey(key: dataPath))
        .thenAnswer((_) async => containsResult);

    final SecureDataContainer sharedPrefDataContainer =
        buildSecureStorageDataContainerWithDependencies(
            dataPath, mockSecureStorage);

    expect(await sharedPrefDataContainer.exists(), containsResult);
    verify(() => mockSecureStorage.containsKey(key: dataPath)).called(1);
  });

  test('write should call flutterSecureStorage.write', () async {
    const fakeWriteValue = 'FooFizzBarBaz';

    final mockFlutterSecureStorage = MockFlutterSecureStorage();

    when(() => mockFlutterSecureStorage.write(
        key: dataPath, value: fakeWriteValue)).thenAnswer((_) async => true);

    final SecureDataContainer sharedPrefDataContainer =
        buildSecureStorageDataContainerWithDependencies(
            dataPath, mockFlutterSecureStorage);

    await sharedPrefDataContainer.write(fakeWriteValue);
    verify(() => mockFlutterSecureStorage.write(
        key: dataPath, value: fakeWriteValue)).called(1);
  });

  test('read should call flutterSecureStorage.read', () async {
    const fakeReadValue = 'FooFizzBarBaz';

    final mockSecureStorage = MockFlutterSecureStorage();

    when(() => mockSecureStorage.containsKey(key: dataPath))
        .thenAnswer((_) async => true);
    when(() => mockSecureStorage.read(key: dataPath))
        .thenAnswer((_) async => fakeReadValue);

    final SecureDataContainer sharedPrefDataContainer =
        buildSecureStorageDataContainerWithDependencies(
            dataPath, mockSecureStorage);

    expect(await sharedPrefDataContainer.read(), fakeReadValue);
    verify(() => mockSecureStorage.read(key: dataPath)).called(1);
  });
}
