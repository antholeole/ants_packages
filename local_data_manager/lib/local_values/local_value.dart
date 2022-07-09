import 'package:local_value/local_data_container/local_data_container.dart';
import 'package:local_value/local_values/local_value_impl.dart';

part 'local_value_di.dart';

/// Local persistance container. [LocalValue] is useful when storing many values (ex. storing multiple users by id).
/// If storing singletons (ex. only storing the currently logged in user), consider using [LocalSingleton]
class LocalValue<T> extends LocalValueImpl<T> {
  /// `documentType` specifies the storage path. see [DocumentType]. (NOTE: this value is ignored on web and always stores to `DocumentType.prefs`.)
  /// [toJson] and [fromJson] are required if storing a non-primative (NOT one of int, double, string, or Map<String, dynamic>).
  /// otherwise, defaults to identity functions.
  /// [basePath] specifies the path that the files are stored to. It is recommended to use this paramater, if only for style:
  /// This is because it is possible to polute the base directory & face collisions.
  ///
  /// ```dart
  /// final localUsers = LocalValue<User>(
  ///   fromJson: User.fromJson,
  ///   toJson: (user) => user.toJson,
  ///   basePath: ['users']
  /// );
  ///
  /// await localUsers.write(user.id, user);
  /// ```
  const LocalValue({
    DocumentType? documentType,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic> Function(T)? toJson,
    List<String>? basePath,
  }) : super(
            documentType: documentType,
            fromJson: fromJson,
            toJson: toJson,
            basePath: basePath,
            localDataContainerCreator: LocalDataContainer.create);

  const LocalValue._di({
    DocumentType? documentType,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic> Function(T)? toJson,
    List<String>? basePath,
    required Future<LocalDataContainer> Function(DocumentType, String)
        localDataContainerCreator,
  }) : super(
            documentType: documentType,
            fromJson: fromJson,
            toJson: toJson,
            basePath: basePath,
            localDataContainerCreator: localDataContainerCreator);

  /// reads from storage according to [LocalValue.basePath] and [LocalValue.documentType].
  /// returns null if nothing is at that path, T if otherwise.
  ///
  /// It is possible to put a path in [id] (i.e. `read('my/path/${user.id}')`),
  /// but is not recommended because subsequent lookups will need to be pathed the same. instead, put
  /// path segments when constructing this [LocalValue].
  Future<T?> read(String id) {
    return super.readValue(id);
  }

  /// writes [toWrite] to storage according to [LocalValue.basePath] and [LocalValue.documentType].
  ///
  /// It is possible to put a path in [id] (i.e. `write('my/path/${user.id}')`),
  /// but is not recommended because subsequent lookups will need to be pathed the same. instead, put
  /// path segments when constructing this [LocalValue].
  Future<void> write(String id, T toWrite) {
    return super.writeValue(id, toWrite);
  }

  /// deletes from storage according to [LocalValue.basePath] and [LocalValue.documentType], returning true
  /// if an object existed at the path and was deleted from storage and false otherwise.
  ///
  /// It is possible to put a path in [id] (i.e. `write('my/path/${user.id}')`),
  /// but is not recommended because subsequent lookups will need to be pathed the same. instead, put
  /// path segments when constructing this [LocalValue].
  Future<bool> delete(String id) {
    return super.deleteValue(id);
  }
}
