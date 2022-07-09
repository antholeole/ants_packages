import 'package:flutter_test/flutter_test.dart';
import 'package:local_value/local_data_container/shared_pref_data_container.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  const dataPath = 'Hello';

  test('delete should call sharedPref.delete and return result', () async {
    const deleteResult = true;
    final mockSharedpreference = MockSharedPreference();

    when(() => mockSharedpreference.remove(dataPath))
        .thenAnswer((_) async => deleteResult);

    final SharedPrefDataContainer sharedPrefDataContainer =
        buildSharedPrefDataContainerWithDependencies(
            dataPath, mockSharedpreference);

    expect(await sharedPrefDataContainer.delete(), deleteResult);
    verify(() => mockSharedpreference.remove(dataPath)).called(1);
  });

  test('exists should call sharedPref.containsKey and return result', () async {
    const containsResult = true;
    final mockSharedpreference = MockSharedPreference();

    when(() => mockSharedpreference.containsKey(dataPath))
        .thenAnswer((_) => containsResult);

    final SharedPrefDataContainer sharedPrefDataContainer =
        buildSharedPrefDataContainerWithDependencies(
            dataPath, mockSharedpreference);

    expect(sharedPrefDataContainer.exists(), containsResult);
    verify(() => mockSharedpreference.containsKey(dataPath)).called(1);
  });

  test('write should call sharedPref.write', () async {
    const fakeWriteValue = 'FooFizzBarBaz';

    final mockSharedpreference = MockSharedPreference();

    when(() => mockSharedpreference.setString(dataPath, fakeWriteValue))
        .thenAnswer((_) async => true);

    final SharedPrefDataContainer sharedPrefDataContainer =
        buildSharedPrefDataContainerWithDependencies(
            dataPath, mockSharedpreference);

    await sharedPrefDataContainer.write(fakeWriteValue);
    verify(() => mockSharedpreference.setString(dataPath, fakeWriteValue))
        .called(1);
  });

  test('read should call sharedPref.getString', () async {
    const fakeReadValue = 'FooFizzBarBaz';

    final mockSharedpreference = MockSharedPreference();

    when(() => mockSharedpreference.getString(dataPath))
        .thenAnswer((_) => fakeReadValue);

    final SharedPrefDataContainer sharedPrefDataContainer =
        buildSharedPrefDataContainerWithDependencies(
            dataPath, mockSharedpreference);

    expect(sharedPrefDataContainer.read(), fakeReadValue);
    verify(() => mockSharedpreference.getString(dataPath)).called(1);
  });
}
