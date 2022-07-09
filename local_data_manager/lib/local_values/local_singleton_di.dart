part of 'local_singleton.dart';

LocalSingleton<T> buildLocalSingleWithDependences<T>({
  required Future<LocalDataContainer> Function(DocumentType, String)
      localDataContainerCreator,
  required String fileName,
  DocumentType? documentType,
  T Function(Map<String, dynamic>)? fromJson,
  Map<String, dynamic> Function(T)? toJson,
}) {
  return LocalSingleton<T>._di(
      localDataContainerCreator: localDataContainerCreator,
      id: fileName,
      documentType: documentType,
      fromJson: fromJson,
      toJson: toJson);
}
