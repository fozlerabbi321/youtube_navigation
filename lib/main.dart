import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Track initialized tabs
  final List<bool> _initializedTabs = [true, false, false, false];

  // Keys to manage navigation for each tab
  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          _initializedTabs[0] ? _buildNavigator(HomePage(navigatorKey: _navigatorKeys[0],), 0) : Container(),
          _initializedTabs[1] ? _buildNavigator(ExplorePage(), 1) : Container(),
          _initializedTabs[2] ? _buildNavigator(SubscriptionsPage(), 2) : Container(),
          _initializedTabs[3] ? _buildNavigator(LibraryPage(), 3) : Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (!_initializedTabs[index]) {
              _initializedTabs[index] = true; // Initialize the tab when clicked for the first time
            }
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', backgroundColor: Colors.red,),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: 'Subscriptions'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
        ],
      ),
    );
  }

  Navigator _buildNavigator(Widget page, int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }
}

class BasePage extends StatelessWidget {
  final String title;
  final Widget child;
  const BasePage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: child),
    );
  }
}



class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    log('ExplorePage build called');
    return BasePage(
      title: "Explore",
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ChannelDetailsPage()),
          );
        },
        child: Text("Open Channel Page"),
      ),
    );
  }
}

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    log('SubscriptionsPage build called');
    return BasePage(
      title: "Subscriptions",
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => SearchPage()),
          );
        },
        child: Text("Open Search Page"),
      ),
    );
  }
}

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    log('LibraryPage build called');
    return BasePage(
      title: "Library",
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => NotificationPage()),
          );
        },
        child: Text("Open Notification Page"),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const HomePage({Key? key,required this.navigatorKey }) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    log('HomePage initState called');
  }

  @override
  Widget build(BuildContext context) {
    log('HomePage build called');
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            widget.navigatorKey.currentState!.push(
              MaterialPageRoute(builder: (_) => VideoPlayerPage()),
            );
          },
          child: Text("Open Video Player"),
        ),
      ),
    );
  }
}


// Other pages
class VideoPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log('onWillPop called on Video Player Page');
        return true; // Allow the pop action to go back to the previous screen
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Video Player"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              bool shouldPop = await _showExitConfirmationDialog(context);
              if (shouldPop) {
                Navigator.of(context).pop(); // Pop the current screen
              }
            },
          ),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SearchPage()),
              );
            },
            child: Text("Open Search Page"),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit Video Player"),
        content: Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Exit"),
          ),
        ],
      ),
    ) ?? false;
  }
}

class ChannelDetailsPage extends StatelessWidget {
  const ChannelDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Channel Details",
      child: Text("Channel Details Content"),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Search Page",
      child: Text("Search Content"),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Notification Page",
      child: Text("Notification Content"),
    );
  }
}
