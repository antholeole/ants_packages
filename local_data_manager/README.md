## Quickstart 

```dart
//locally save a singleton:
final localCounterValue = LocalSingleton<int>(id: 'counter_val');
await localCounterValue.write(5);
print(await localCounterValue.read()); //5

//or save multiple related objects:
final localUserScores = LocalValue<int>(basePath: ['user_scores']);

await localUserScores.write('user_1', 15); 
await localUserScores.write('user_2', 24)

print(await localUserScores.read('user_1')); //prints 15
print(await localUserScores.read('user_2')); //prints 24
```

## Features

helps save / load / delete singletons to local storage. 

you can specify if the document is a application document, temporary document, support document, or shared prefrence. The distinction can be found [here](https://pub.dev/documentation/path_provider/latest/path_provider/getTemporaryDirectory.html).

In short:

- `DocumentType.document`: data that is user generated and cannot be recreated. (ex. my high score in a local-only game)
- `DocumentType.support`: data that is NOT user generated and cannot be recreated. (ex. automatically set config files)
- `DocumentType.temporary`: data that can be cleared at any time. (ex. caching a downloaded json)
- `DocumentType.secure`: data that must be stored securely. (ex. a users API keys)
- `DocumentType.prefs`: user preference (ex. should the app open in light mode)


> NOTE: Web uses [shared_preferences](https://pub.dev/packages/shared_preferences) on the backend instead of real files. this is because on web, there is no notion of files. 



## Use cases

Saving the logged in user:

```dart
class CurrentUser {
    final int id;
    final String name;
    final Color favoriteColor;

    // insert toJson here
    // insert fromJson here
}

final locallyPersistedUser = localSingleton<CurrentUser>(
      id: 'current_user',
      fromJson: CurrentUser.fromJson,
      toJson: (currentUser) => currentUser.toJson());


//save and load the user to memory like this:
CurrentUser? myCurrentUser = await locallyPersistedUser.read();
await locallyPersistedUser.write(someUser);
```

Caching many things to memory to avoid redundant network calls:

```dart
final localUsers = LocalValue<User>(toJson: ..., fromJson: ...);

await localUsers.read(userOneId);
await localUsers.write(userTwoId, userTwo);
```

Strongly typed way to save things to shared preference:

```dart
final isDarkMode = LocalSingleton<User>(documentType: DocumentType.prefs, id: 'isDarkMode');
await isDarkMode.write(true);
final darkMode = await isDarkMode.read() ?? false;
```

## LocalValue vs LocalSingleton

This package exposes `LocalValue` and `LocalSingleton`. both share a very similar API, but one key difference: `LocalSingleton` always saves to the same file - this is beneficial for use cases where you only need to store one value - something like the current user's data.

If you have to store data on many users, consider `LocalValue`, which requires an `id` for read, write, and delete

## Usage

```dart

//preface: import it!
import 'package:local_value/local_value.dart';

//first, create some sort of data model you want to save to local storage.
//can be a primative (just use LocalValue<int> or similar)
class CounterObj {
    int value;

    CounterObj(this.value);
}


//localSingleton is used for singletons,
final counterFile = localSingleton<CounterObj>(
      documentType: DocumentType.document, //optional, defaults to document
      id: 'counter', //required to be unique

      //from and to json are required for primatives
      fromJson: (counterJson) => CounterObj(counterJson['value'] as int), 
      toJson: (counterObj) => {'value': counterObj.value}
    );



//read from it
CounterObj? myCurrentCounter = await counterStorage.read();

//write to it
await counterStorage.write(myCurrentCounter ?? CounterObj(8));

//clear it
await counterStorage.clear();
```

## Additional information

If you find an issue, please post it on the github. 

I am actively maintaining this package and am open to feature requests. Please leave an issue on the github for anything.

This package's inital development is complete (fully unit test covered, all initally planned features are complete) but feature requests are welcome. Since this is built as an abstraction over two very well tested packages (`shared_preferences` and `path_provder`), this package is stable. 