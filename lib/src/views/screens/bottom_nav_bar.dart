import 'package:flutter/material.dart';

import '../../features/city/screens/search_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/home/screens/home_screen.dart';
import 'map_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(),
    HistoryScreen(),
    MapScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_selectedIndex].currentState!.maybePop();

        debugPrint(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: List.generate(_navigatorKeys.length, (index) {
            return _buildOffstageNavigator(index);
          }),
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all<TextStyle>(
              theme.textTheme.subtitle2!.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
            backgroundColor: theme.colorScheme.primary,
            indicatorColor: theme.colorScheme.secondaryContainer,
            iconTheme: MaterialStateProperty.all<IconThemeData>(
              IconThemeData(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
          child: NavigationBar(
            backgroundColor: theme.colorScheme.background,
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search_rounded),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined),
                activeIcon: Icon(Icons.book_rounded),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map_rounded),
                label: 'Maps',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute(
            builder: (context) => _widgetOptions[index],
          );
        },
      ),
    );
  }
}
