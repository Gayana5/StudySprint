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
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Сессии'),
          NavigationDestination(icon: Icon(Icons.timer), label: 'Таймер'),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Статистика'),
          NavigationDestination(icon: Icon(Icons.flag), label: 'Цели'),
        ],
      ),
    );
  }
}
