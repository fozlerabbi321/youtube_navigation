import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

BuildContext? globalContext;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) {
        if (globalContext != null) {
          Navigator.of(globalContext!).pop();
        } else {
          // If globalContext is null, then the app is running on the main screen and we can just close the app
          log('globalContext is null, closing app');
          if(_currentIndex == 0){
            //SystemNavigator.pop();
          }else{
            setState(() {
              _currentIndex = 0;
            });
          }
        }
        log('onPopInvoked called on Main Screen with value: $value');
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            _initializedTabs[0] ? _buildNavigator(0) : Container(),
            _initializedTabs[1] ? _buildNavigator(1) : Container(),
            _initializedTabs[2] ? _buildNavigator(2) : Container(),
            _initializedTabs[3] ? _buildNavigator(3) : Container(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (_currentIndex == index) {
              _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
            }else{
              setState(() {
                if (!_initializedTabs[index]) {
                  _initializedTabs[index] = true; // Initialize the tab when clicked for the first time
                }
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
      ),
    );
  }

  Navigator _buildNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        Widget page;
        switch (routeSettings.name) {
          case '/videoPlayer':
            page = const VideoPlayerPage();
            break;
          case '/channelDetails':
            page = const ChannelDetailsPage();
            break;
          case '/search':
            page = const SearchPage();
            break;
          case '/notification':
            page = const NotificationPage();
            break;
          default:
            page = _getInitialPageForTab(index);
        }
        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }

  Widget _getInitialPageForTab(int index) {
    switch (index) {
      case 0:
        return HomePage(navigatorKey: _navigatorKeys[0]);
      case 1:
        return const ExplorePage();
      case 2:
        return const SubscriptionsPage();
      case 3:
        return const LibraryPage();
      default:
        return Container();
    }
  }
}

class HomePage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const HomePage({Key? key, required this.navigatorKey}) : super(key: key);

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
    return BasePage(
      title: "Home",
      child: ElevatedButton(
        onPressed: () async{
          await Navigator.of(context).pushNamed('/videoPlayer');
          globalContext = null;
          log('globalContext: $globalContext');
        },
        child: const Text("Open Video Player"),
      ),
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
      body: Column(
        children: [
          Center(child: child),
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        ],
      ),
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
        onPressed: () async{
          await Navigator.of(context).pushNamed('/channelDetails');
          globalContext = null;
          log('globalContext: $globalContext');
        },
        child: const Text("Open Channel Page"),
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
        onPressed: () async{
          await Navigator.of(context).pushNamed('/search');
          globalContext = null;
          log('globalContext: $globalContext');
        },
        child: const Text("Open Search Page"),
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
        onPressed: () async{
          await Navigator.of(context).pushNamed('/notification');
          globalContext = null;
          log('globalContext: $globalContext');
        },
        child: const Text("Open Notification Page"),
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  void initState() {
    super.initState();
    globalContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed('/search');
            globalContext = context;
            log('globalContext: $globalContext');
          },
          child: const Text("Open Search Page"),
        ),
      ),
    );
  }
}

class ChannelDetailsPage extends StatefulWidget {
  const ChannelDetailsPage({super.key});

  @override
  State<ChannelDetailsPage> createState() => _ChannelDetailsPageState();
}

class _ChannelDetailsPageState extends State<ChannelDetailsPage> {
  @override
  void initState() {
    super.initState();
    globalContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Channel Details",
      child: const Text("Channel Details Content"),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    globalContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Search Page",
      child: const Text("Search Content"),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    globalContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Notification Page",
      child: const Text("Notification Content"),
    );
  }
}
