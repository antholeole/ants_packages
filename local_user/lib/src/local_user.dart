import 'package:flutter/foundation.dart';
import 'package:local_user/src/local_user_state.dart';
import 'package:local_value/local_value.dart';
import 'package:uuid_type_next/uuid_type_next.dart';

class LocalUser extends ChangeNotifier
    implements ValueListenable<LocalUserState> {
  final LocalSingleton<String> _localRefreshToken = LocalSingleton(
    id: 'refresh_token',
    documentType: DocumentType.secure,
  );
  final LocalSingleton<String> _localUserId = LocalSingleton(
    id: 'user_id',
    documentType: DocumentType.secure,
  );

  LocalUserState _state = LocalUserLoadingState();

  /// begins an async process that checks if the user is logged in or not.
  Future<void> determineState() async {
    final tokens =
        await Future.wait([_localRefreshToken.read(), _localUserId.read()]);

    final refreshToken = tokens[0];
    final userId = tokens[1];

    if (refreshToken == null || userId == null) {
      logOut();
    } else {
      logIn(UuidType(userId), refreshToken);
    }
  }

  @override
  LocalUserState get value => _state;

  K? maybeOn<K>({
    K Function(Exception? e)? loggedOut,
    K Function(UuidType userId)? loggedIn,
    K Function()? loading,
  }) {
    if (_state is LocalUserLoggedInState && loggedIn != null) {
      return loggedIn((_state as LocalUserLoggedInState).userId);
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
    required K Function(UuidType) loggedIn,
    required K Function() loading,
  }) {
    if (_state is LocalUserLoggedInState) {
      return loggedIn((_state as LocalUserLoggedInState).userId);
    }

    if (_state is LocalUserLoggedOutState) {
      return loggedOut((_state as LocalUserLoggedOutState).withException);
    }

    return loading();
  }

  Future<void> logIn(UuidType userId, String refreshToken) async {
    //don't notify if we're already logged
    final shouldNotify = _state is LocalUserLoggedInState;
    _state = LocalUserLoggedInState(userId);

    await Future.wait([
      _localRefreshToken.write(refreshToken),
      _localUserId.write(userId.toString())
    ]);

    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<void> logOut({Exception? withException}) async {
    //if we were already logged out, and we aren't forcing one due to an exception
    if (_state is LocalUserLoggedOutState && withException == null) {
      return;
    }

    await Future.wait([_localRefreshToken.delete(), _localUserId.delete()]);

    _state = LocalUserLoggedOutState(withException: withException);
    notifyListeners();
  }

  Future<String?> get refreshToken {
    if (_state is LocalUserLoggedInState) {
      return _localRefreshToken.read();
    } else {
      return Future.value(null);
    }
  }
}
