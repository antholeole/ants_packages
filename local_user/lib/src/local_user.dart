import 'package:flutter/foundation.dart';
import 'package:local_user/src/local_user_state.dart';
import 'package:local_value/local_value.dart';
import 'package:uuid_type_next/uuid_type_next.dart';

class LocalUser extends ChangeNotifier
    implements ValueListenable<LocalUserState> {
  static const String _uuidKey = 'userId';
  static const String _refreshTokenKey = 'refreshToken';

  final LocalSingleton<LocalUserLoggedInState> _localUser = LocalSingleton(
      id: 'local_user',
      documentType: DocumentType.secure,
      toJson: (localUser) => {
            _uuidKey: localUser.userId.toString(),
            _refreshTokenKey: localUser.refreshToken
          },
      fromJson: (json) => LocalUserLoggedInState(
          UuidType(json[_uuidKey]), json[_refreshTokenKey]));

  LocalUserState _state = LocalUserLoadingState();

  /// begins an async process that checks if the user is logged in or not.
  Future<void> determineState() async {
    final maybeLoggedInState = await _localUser.read();

    if (maybeLoggedInState == null) {
      logOut();
    } else {
      logIn(maybeLoggedInState.userId, maybeLoggedInState.refreshToken);
    }
  }

  @override
  LocalUserState get value => _state;

  K? maybeOn<K>({
    K Function(Exception? e)? loggedOut,
    K Function(LocalUserLoggedInState)? loggedIn,
    K Function()? loading,
  }) {
    if (_state is LocalUserLoggedInState && loggedIn != null) {
      return loggedIn(_state as LocalUserLoggedInState);
    }

    if (_state is LocalUserLoggedOutState && loggedOut != null) {
      return loggedOut((_state as LocalUserLoggedOutState).withException);
    }

    if (_state is LocalUserLoadingState && loading != null) {
      return loading();
    }

    return null;
  }

  K on<K>({
    required K Function(Exception? e) loggedOut,
    required K Function(LocalUserLoggedInState) loggedIn,
    required K Function() loading,
  }) {
    if (_state is LocalUserLoggedInState) {
      return loggedIn(_state as LocalUserLoggedInState);
    }

    if (_state is LocalUserLoggedOutState) {
      return loggedOut((_state as LocalUserLoggedOutState).withException);
    }

    return loading();
  }

  Future<void> logIn(UuidType userId, String refreshToken) async {
    //don't notify if we're already logged
    final shouldNotify = _state is LocalUserLoggedInState;
    _state = LocalUserLoggedInState(userId, refreshToken);

    await _localUser.write(LocalUserLoggedInState(userId, refreshToken));

    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<void> logOut({Exception? withException}) async {
    //if we were already logged out, and we aren't forcing one due to an exception
    if (_state is LocalUserLoggedOutState && withException == null) {
      return;
    }

    await _localUser.delete();

    _state = LocalUserLoggedOutState(withException: withException);
    notifyListeners();
  }
}
