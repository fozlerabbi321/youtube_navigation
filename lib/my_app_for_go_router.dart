import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
final _rootNavigatorKey = GlobalKey<NavigatorState>();

class MyGoRouterApp extends StatelessWidget {
  MyGoRouterApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
          ),
          GoRoute(
            path: '/explore',
            name: 'explore',
            pageBuilder: (context, state) => const MaterialPage(child: ExplorePage()),
          ),
          GoRoute(
            path: '/subscriptions',
            name: 'subscriptions',
            pageBuilder: (context, state) => const MaterialPage(child: SubscriptionsPage()),
          ),
          GoRoute(
            path: '/library',
            name: 'library',
            pageBuilder: (context, state) => const MaterialPage(child: LibraryPage()),
          ),
          GoRoute(
            path: '/videoPlayer',
            name: 'videoPlayer',
            pageBuilder: (context, state) => const MaterialPage(child: VideoPlayerPage()),
          ),
          GoRoute(
            path: '/channelDetails',
            name: 'channelDetails',
            pageBuilder: (context, state) => const MaterialPage(child: ChannelDetailsPage()),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            pageBuilder: (context, state) => const MaterialPage(child: SearchPage()),
          ),
          GoRoute(
            path: '/notification',
            name: 'notification',
            pageBuilder: (context, state) => const MaterialPage(child: NotificationPage()),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}


class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithNavBar({required this.child, super.key});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {

  int _currentIndex = 0;

  Future<void> _onPopInvoked(bool didPop) async {
    final GoRouterState state = GoRouterState.of(context);
    final GoRouter router = GoRouter.of(context);
    // Check if the current location is the root route of the tab
    final isFirstRouteInCurrentTab = _isFirstRouteInTab(state.uri.path);
    if (isFirstRouteInCurrentTab) {
      if (_currentIndex != 0) {
        // If not on the first tab, switch to the first tab
        setState(() {
          _currentIndex = 0;
        });
        router.go('/home'); // Navigate to the home tab
       // return false;
      } else {
        log('The user is trying to pop the first route in the current tab');
        // Here you can show a dialog or perform other actions, e.g., double back to exit.
       // return true; // Allow app to exit
      }
    } else {
      router.pop(); // Pop the current route
      //return false; // Prevent further popping
    }
  }

  bool _isFirstRouteInTab(String location) {
    switch (_currentIndex) {
      case 0:
        return location == '/home';
      case 1:
        return location == '/explore';
      case 2:
        return location == '/subscriptions';
      case 3:
        return location == '/library';
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: _onPopInvoked,
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/explore');
                break;
              case 2:
                context.go('/subscriptions');
                break;
              case 3:
                context.go('/library');
                break;
            }
            setState(() {
              _currentIndex = index;
            });
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

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).path ?? '/home';
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/explore')) {
      return 1;
    }
    if (location.startsWith('/subscriptions')) {
      return 2;
    }
    if (location.startsWith('/library')) {
      return 3;
    }
    return 0;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    log('HomePage build called');
    return BasePage(
      title: "Home",
      child: ElevatedButton(
        onPressed: () {
         // Navigator.of(context).pushNamed('/videoPlayer');
          context.go('/videoPlayer');
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
        onPressed: () async {
          context.go('/channelDetails');
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
        onPressed: () async {
          context.go('/search');
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
        onPressed: () async {
          context.go('/notification');
        },
        child: const Text("Open Notification Page"),
      ),
    );
  }
}

class VideoPlayerPage extends StatelessWidget {
  const VideoPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Player"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            context.go('/search');
          },
          child: const Text("Open Search Page"),
        ),
      ),
    );
  }
}

class ChannelDetailsPage extends StatelessWidget {
  const ChannelDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Channel Details",
      child: const Text("Channel Details Content"),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Search Page",
      child: const Text("Search Content"),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Notification Page",
      child: const Text("Notification Content"),
    );
  }
}


