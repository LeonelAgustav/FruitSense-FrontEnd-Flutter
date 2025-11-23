import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

import 'scan/scan_hub_screen.dart';
import 'inventory/inventory_screen.dart';
import 'history/history_screen.dart';
import 'profile/profile_menu_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int initialTab;

  const DashboardScreen({super.key, this.initialTab = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _currentIndex;

  final List<Widget> _pages = [
    const ScanHubScreen(),
    const InventoryScreen(),
    const HistoryScreen(),
    const ProfileMenuScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0, 
      
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        setState(() {
          _currentIndex = 0;
        });
      },
      
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        
        // extendBody: true,
        bottomNavigationBar: BottomNavigationBarWidget(
          selectedTab: _currentIndex,
          onTabSelected: _onTabChange,
        ),
      ),
    );
  }
}