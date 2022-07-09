import 'package:local_value/local_data_container/local_data_container.dart';
import 'package:local_value/local_values/local_value_impl.dart';

part 'local_singleton_di.dart';

class LocalSingleton<T> extends LocalValueImpl<T> {
  final String id;

  /// Local persistance container for singletons.
  ///
  /// [LocalSingleton] will _always_ save to the same base path and offers no variability;
  /// consider [LocalValue] when storing to different paths (ex. storing users by ID).
  ///
  /// see [LocalValue] for explinations on `toJson` `fromJson`, and `documentType`.
  const LocalSingleton(
      {required this.id,
      DocumentType? documentType,
      T Function(Map<String, dynamic>)? fromJson,
      Map<String, dynamic> Function(T)? toJson})
      : super(
            documentType: documentType,
            fromJson: fromJson,
            toJson: toJson,
            localDataContainerCreator: LocalDataContainer.create);

  LocalSingleton._di(
      {required this.id,
      required Future<LocalDataContainer> Function(DocumentType, String)
          localDataContainerCreator,
      DocumentType? documentType,
      T Function(Map<String, dynamic>)? fromJson,
      Map<String, dynamic> Function(T)? toJson})
      : super(
            documentType: documentType,
            fromJson: fromJson,
            toJson: toJson,
            localDataContainerCreator: localDataContainerCreator);

  Future<T?> read() {
    return super.readValue(id);
  }

  Future<void> write(T toWrite) {
    return super.writeValue(id, toWrite);
  }

  Future<void> delete() {
    return super.deleteValue(id);
  }
}
