import 'package:uuid_type/uuid_type.dart';

abstract class LocalUserState {
  const LocalUserState();
}

class LocalUserLoggedInState extends LocalUserState {
  final UuidType userId;

  const LocalUserLoggedInState(this.userId);
}

class LocalUserLoadingState extends LocalUserState {
  const LocalUserLoadingState();
}

class LocalUserLoggedOutState extends LocalUserState {
  final Exception? withException;

  const LocalUserLoggedOutState({this.withException});
}
