import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Keys to manage navigation for each tab
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        alignment: Alignment.bottomCenter,
        children: [
          IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              Navigator(
                key: _navigatorKeys[0],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (_) => HomePage(navigatorKey: _navigatorKeys[0]));
                },
              ),
              Navigator(
                key: _navigatorKeys[1],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (_) => ExplorePage(navigatorKey: _navigatorKeys[1]));
                },
              ),
              Navigator(
                key: _navigatorKeys[2],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (_) => SubscriptionsPage(navigatorKey: _navigatorKeys[2]));
                },
              ),
              Navigator(
                key: _navigatorKeys[3],
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(builder: (_) => LibraryPage(navigatorKey: _navigatorKeys[3]));
                },
              ),
            ],
          ),

          // Bottom navigation
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            color: Colors.blueAccent ,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex == index) {
            // Check if we are already at the first route in the stack
            _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', backgroundColor: Colors.red),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.subscriptions), label: 'Subscriptions'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  HomePage({required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (_) => VideoPlayerPage()),
            );
          },
          child: Text("Open Video Player"),
        ),
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  ExplorePage({required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Explore")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (_) => ChannelDetailsPage()),
            );
          },
          child: Text("Open Channel Page"),
        ),
      ),
    );
  }
}

class SubscriptionsPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  SubscriptionsPage({required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Subscriptions")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (_) => SearchPage()),
            );
          },
          child: Text("Open Search Page"),
        ),
      ),
    );
  }
}

class LibraryPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  LibraryPage({required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Library")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (_) => NotificationPage()),
            );
          },
          child: const Text("Open Notification Page"),
        ),
      ),
    );
  }
}

// Video Player Page Example
class VideoPlayerPage extends StatelessWidget {
  const VideoPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Player")),
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
    );
  }
}

// Channel Details Page Example
class ChannelDetailsPage extends StatelessWidget {
  const ChannelDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Channel Details")),
      body: Center(child: Text("Channel Details Content")),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Page")),
      body: Center(child: Text("Search Content")),
    );
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification Page")),
      body: Center(child: Text("Notification Content")),
    );
  }
}