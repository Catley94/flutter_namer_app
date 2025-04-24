import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Currently at: https://codelabs.developers.google.com/codelabs/flutter-codelab-first#8

void main() {
  // Tells Flutter to run the app defined in MyApp
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /*
    Extends StatelessWidget (Widgets: https://www.youtube.com/watch?v=wE7khGHVkYY)
    MyApp 
    Creates the App-Wide state, 
    Names the app, 
    Defines the visual theme,
    and sets the "home" widget (The starting point of the App)
  */

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromRGBO(0, 255, 0, 1.0)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  /*
    Defines the App's State.
    ChangeNotifier being one of the ways to manage States.

    MyAppState defines the data the app needs to function.
    At the beginning this only contains one random word pair.

    Extending ChangeNotifier allows this State to notify others about it's own changes.
    For example, if the word pair changes, some widgets in the app need to know.

    The state is created and provided to the whole app using ChangeNotifierProvider (See in MyApp),
      this allows any widget in the app to get hold of the state.

  */
  var current = WordPair.random();
  void getNext() {
    // Get's a new WordPair
    current = WordPair.random();
    /* 
      A method of ChangeNotifier, 
        that ensures anyone watching MyAppState is notified.
    */
    notifyListeners();
  }

  var favourites = <WordPair>[];

  void toggleFavourite() {
    if (favourites.contains(current)) {
      favourites.remove(current);
    } else {
      favourites.add(current);
    }
    notifyListeners();
  }

  void clearFavourites() {
    favourites = <WordPair>[];
    notifyListeners();
  }
}

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favourites = appState.favourites;

    if (favourites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              appState.clearFavourites();
            },
            icon: Icon(Icons.delete),
            label: Text('Clear all favourites'),
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Text("You have " "${favourites.length} favourites:")),
          for (WordPair favourite in favourites)
            ListTile(
                leading: Icon(Icons.favorite),
                title: Text(favourite.asLowerCase))
        ],
      ),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   /*
//     build() is called every time the widget's circumstances change,
//      so that the widget is always up to date.

//     MyHomePage tracks changes to the app's current state using the 'watch' method.

//     Every build() method must return a widget or a nested tree of widgets.
//     In this case, the top level widget is a Scaffold widget.

//     Column is one of the mostbasic layout widgets,
//       it takes any number of children and puts them in a column from top to bottom.
//       By default the children will be placed at the top but can be customised.

//     Text is a widget that displays Text.
//     The second Text widget takes the appState's only member 'current',
//       which is a WordPair.
//       WordPair can also be used with asPascalCase, asSnakeCase and asLowerCase.

//   */
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//     IconData icon;
//     if (appState.favourites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             BigCard(pair: pair),
//             SizedBox(height: 10),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     appState.toggleFavourites();
//                   },
//                   icon: Icon(icon),
//                   label: Text("Like"),
//                 ),
//                 SizedBox(width: 40),
//                 ElevatedButton(
//                   onPressed: () {
//                     appState.getNext();
//                   },
//                   child: Text("Next"),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavouritesPage();
      default:
        throw UnimplementedError("No widget for $selectedIndex");
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favourites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavourite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    /*
      Accessing App's font theme.
      Look at the description of displayMedium for more info.

      copyWith returns a copy of that text style with the changes defined.
        In this case, we're just changing the text colour.
        onPrimary indicating that it's the colour ontop of the Primary colour.
    */
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  const SmallCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    /*
      Accessing App's font theme.
      Look at the description of displayMedium for more info.

      copyWith returns a copy of that text style with the changes defined.
        In this case, we're just changing the text colour.
        onPrimary indicating that it's the colour ontop of the Primary colour.
    */
    final style = theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
