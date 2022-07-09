part of 'local_value.dart';

LocalValue<T> buildLocalValueWithDependences<T>({
  required Future<LocalDataContainer> Function(DocumentType, String)
      localDataContainerCreator,
  List<String>? basePath,
  DocumentType? documentType,
  T Function(Map<String, dynamic>)? fromJson,
  Map<String, dynamic> Function(T)? toJson,
}) {
  return LocalValue._di(
      localDataContainerCreator: localDataContainerCreator,
      basePath: basePath,
      documentType: documentType,
      fromJson: fromJson,
      toJson: toJson);
}
