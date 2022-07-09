part of 'shared_pref_data_container.dart';

SharedPrefDataContainer buildSharedPrefDataContainerWithDependencies(
    String path, SharedPreferences sharedPreferences) {
  return SharedPrefDataContainer._(path, sharedPreferences);
}
