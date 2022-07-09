import 'package:uuid_type_next/uuid_type_next.dart';

abstract class LocalUserState {
  const LocalUserState();
}

class LocalUserLoggedInState extends LocalUserState {
  final UuidType userId;
  final String refreshToken;

  const LocalUserLoggedInState(this.userId, this.refreshToken);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is LocalUserLoggedInState &&
        other.userId == userId &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode => userId.hashCode;
}

class LocalUserLoadingState extends LocalUserState {
  const LocalUserLoadingState();
}

class LocalUserLoggedOutState extends LocalUserState {
  final Exception? withException;

  const LocalUserLoggedOutState({this.withException});
}
