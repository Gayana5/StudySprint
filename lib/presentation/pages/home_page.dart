import 'package:flutter/material.dart';

import 'goals_page.dart';
import 'sessions_page.dart';
import 'stats_page.dart';
import 'timer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final _pages = const [
    SessionsPage(),
    TimerPage(),
    StatsPage(),
    GoalsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() => _index = value);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt, color: Color(0xFF00FFFF)), label: 'SESSIONS'),
          NavigationDestination(icon: Icon(Icons.timer, color: Color(0xFFFF00FF)), label: 'TIMER'),
          NavigationDestination(icon: Icon(Icons.insights, color: Color(0xFFFFFF00)), label: 'STATS'),
          NavigationDestination(icon: Icon(Icons.flag, color: Color(0xFF00FF00)), label: 'GOALS'),
        ],
      ),
    );
  }
}
