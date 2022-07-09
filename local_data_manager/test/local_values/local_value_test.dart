import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_value/local_values/local_value.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';
import '../setups.dart';

void main() {
  final fakeBasePath = ['hi', 'bye', 'basePath'];
  const fakeFileName = 'thisIsFileName';

  // we shouldn't construct this value manually since we'd be making assumptions about
  // how it's constructed.
  const builtPath = 'hi/bye/basePath/thisIsFileName.json';

  setUp(() {
    registerTestFallbackValues();
  });

  test('should fail assert if non-primative without to/fromJson', () {
    expect(() => LocalValue<FakeObject>(), throwsA(isA<AssertionError>()));
  });

  test('should not fail assert if to/fromJson proviced for non-primative', () {
    expect(
        () => LocalValue<FakeObject>(
              fromJson: FakeObject.fromJson,
              toJson: (fakeObject) => fakeObject.toJson(),
            ),
        isNot(throwsA(isA<AssertionError>())));
  });

  test('should allow construction of primative without to and from json', () {
    expect(() => LocalValue<String>(), isNot(throwsA(isA<AssertionError>())));
    expect(() => LocalValue<int>(), isNot(throwsA(isA<AssertionError>())));
    expect(() => LocalValue<double>(), isNot(throwsA(isA<AssertionError>())));

    expect(() => LocalValue<Map<String, dynamic>>(),
        isNot(throwsA(isA<AssertionError>())));
  });

  group('read', () {
    test('should read primative from json with key "value"', () async {
      const readValue = 'BLAH BLAH';

      final MockLocalDataContainer mockLocalDataContainer =
          MockLocalDataContainer();
      final mockLocalDataContainerCreator = MockLocalDataContainerCreator();
      when(() => mockLocalDataContainerCreator.getContainer(any(), builtPath))
          .thenAnswer((_) async => mockLocalDataContainer);

      when(() => mockLocalDataContainer.read())
          .thenAnswer((_) async => json.encode({'value': readValue}));

      final localValue = buildLocalValueWithDependences<String>(
        localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
        basePath: fakeBasePath,
      );

      expect(await localValue.read(fakeFileName), readValue);
    });
    test('should call fromJson during load on non-primative', () async {
      const fakePropertyValue = 1;

      final MockCaller fromJsonMock = MockCaller();
      final MockLocalDataContainer mockLocalDataContainer =
          MockLocalDataContainer();
      final mockLocalDataContainerCreator = MockLocalDataContainerCreator();

      when(() => mockLocalDataContainerCreator.getContainer(any(), builtPath))
          .thenAnswer((_) async => mockLocalDataContainer);
      when(() => mockLocalDataContainer.read()).thenAnswer((_) async => json
          .encode(const FakeObject(fakeProperty: fakePropertyValue).toJson()));

      final localValue = buildLocalValueWithDependences<FakeObject>(
        localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
        basePath: fakeBasePath,
        fromJson: (json) {
          fromJsonMock.call();
          return FakeObject.fromJson(json);
        },
        toJson: (p0) => p0.toJson(),
      );

      expect((await localValue.read(fakeFileName))?.fakeProperty,
          fakePropertyValue);
      verify(() => fromJsonMock.call()).called(1);
    });
    test('should return null on objectContainer.read returns null', () async {
      final MockLocalDataContainer mockLocalDataContainer =
          MockLocalDataContainer();
      final mockLocalDataContainerCreator = MockLocalDataContainerCreator();
      when(() => mockLocalDataContainerCreator.getContainer(any(), builtPath))
          .thenAnswer((_) async => mockLocalDataContainer);

      when(() => mockLocalDataContainer.read()).thenAnswer((_) async => null);

      final localValue = buildLocalValueWithDependences<String>(
        localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
        basePath: fakeBasePath,
      );

      expect(await localValue.read(fakeFileName), null);
    });

    test('should return T on objectContainer.read returns T', () async {
      const fakeObj = FakeObject(fakeProperty: 1);

      final MockLocalDataContainer mockLocalDataContainer =
          MockLocalDataContainer();
      final mockLocalDataContainerCreator = MockLocalDataContainerCreator();
      when(() => mockLocalDataContainerCreator.getContainer(any(), builtPath))
          .thenAnswer((_) async => mockLocalDataContainer);

      when(() => mockLocalDataContainer.read())
          .thenAnswer((_) async => json.encode(fakeObj.toJson()));

      final localValue = buildLocalValueWithDependences<FakeObject>(
        localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
        basePath: fakeBasePath,
        toJson: (fakeObject) => fakeObject.toJson(),
        fromJson: FakeObject.fromJson,
      );

      expect((await localValue.read(fakeFileName))?.fakeProperty,
          fakeObj.fakeProperty);
    });
  });

  group('write', () {
    test('should call toJson on object', () async {
      final MockCaller toJsonMock = MockCaller();
      final MockLocalDataContainer mockLocalDataContainer =
          MockLocalDataContainer();
      final mockLocalDataContainerCreator = MockLocalDataContainerCreator();

      when(() => mockLocalDataContainerCreator.getContainer(any(), builtPath))
          .thenAnswer((_) async => mockLocalDataContainer);

      final localValue = buildLocalValueWithDependences<FakeObject>(
        localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
        basePath: fakeBasePath,
        fromJson: FakeObject.fromJson,
        toJson: (p0) {
          toJsonMock.call();
          return p0.toJson();
        },
      );

      await localValue.write(fakeFileName, const FakeObject(fakeProperty: 1));

      verify(() => toJsonMock.call()).called(1);
    });
  });

  test('should perform operations at basePath + fileName', () async {
    final MockLocalDataContainer mockLocalDataContainer =
        MockLocalDataContainer();
    final mockLocalDataContainerCreator = MockLocalDataContainerCreator();
    when(() => mockLocalDataContainerCreator.getContainer(any(), any()))
        .thenAnswer((_) async => mockLocalDataContainer);

    final localValue = buildLocalValueWithDependences<String>(
      localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
      basePath: fakeBasePath,
    );

    await localValue.read(fakeFileName);

    expect(
        verify(() =>
                mockLocalDataContainerCreator.getContainer(any(), captureAny()))
            .captured[0],
        'hi/bye/basePath/thisIsFileName.json');
  });

  test('should call delete on data container and return result', () async {
    const returnVal = true;

    final MockLocalDataContainer mockLocalDataContainer =
        MockLocalDataContainer();
    final mockLocalDataContainerCreator = MockLocalDataContainerCreator();

    when(() => mockLocalDataContainerCreator.getContainer(any(), any()))
        .thenAnswer((_) async => mockLocalDataContainer);
    when(() => mockLocalDataContainer.delete())
        .thenAnswer((invocation) async => returnVal);

    final localValue = buildLocalValueWithDependences<String>(
      localDataContainerCreator: mockLocalDataContainerCreator.getContainer,
      basePath: fakeBasePath,
    );

    expect(await localValue.delete('blah'), returnVal);
    verify(() => mockLocalDataContainer.delete()).called(1);
  });
}
