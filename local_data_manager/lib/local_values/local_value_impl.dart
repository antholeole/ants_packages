import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:local_value/local_data_container/local_data_container.dart';

enum DocumentType { document, support, temporary, prefs, secure }

/// This is an internal implementation of [LocalValue]. required so that we can overload
/// ([LocalSingleton] and [LocalValue] both have read and write methods with different paramaters).
/// All doc comments are in [LocalValue].
abstract class LocalValueImpl<T> {
  final DocumentType _documentType;

  final Map<String, dynamic> Function(T)? _toJson;
  final T Function(Map<String, dynamic>)? _fromJson;

  final List<String> _basePath;

  final Future<LocalDataContainer> Function(
      DocumentType documentType, String fileName) _localDataContainerCreator;

  static const _fileExtension = 'json';

  const LocalValueImpl({
    DocumentType? documentType,
    final Map<String, dynamic> Function(T)? toJson,
    final T Function(Map<String, dynamic>)? fromJson,
    final List<String>? basePath,
    required final Future<LocalDataContainer> Function(
            DocumentType documentType, String fileName)
        localDataContainerCreator,
  })  : assert(
            (toJson == null && fromJson == null) ||
                (toJson != null && fromJson != null),
            'a toJson must have a corresponding fromJson and visa versa.'),
        assert(
            toJson != null ||
                (T == double ||
                    T == int ||
                    T == String ||
                    T == Map<String, dynamic>),
            'Must have custom toJson and fromJson if not using a json primative (int, double, string, or Map<String, dynamic>).'),
        _documentType = kIsWeb
            ? DocumentType.prefs
            : (documentType ?? DocumentType.document),
        _toJson = toJson,
        _fromJson = fromJson,
        _basePath = basePath ?? const [],
        _localDataContainerCreator = localDataContainerCreator;

  @protected
  // @nodoc
  Future<T?> readValue(String fileName) async {
    final maybeString = await (await _container(fileName)).read();

    if (maybeString == null) {
      return null;
    }

    return (_fromJson ?? (json) => json['value'] as T)
        .call(json.decode(maybeString));
  }

  @protected
  Future<void> writeValue(String fileName, T toWrite) async {
    return (await _container(fileName))
        .write(json.encode((_toJson ?? (value) => {'value': value})(toWrite)));
  }

  @protected
  Future<bool> deleteValue(String fileName) async {
    return (await _container(fileName)).delete();
  }

  FutureOr<LocalDataContainer> _container(String fileName) async {
    final builtPath = "${[..._basePath, fileName].join('/')}.$_fileExtension";

    return await _localDataContainerCreator(_documentType, builtPath);
  }
}
