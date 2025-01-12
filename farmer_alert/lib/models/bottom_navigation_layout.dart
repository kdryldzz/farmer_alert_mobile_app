import 'package:farmer_alert/view/home_page.dart';
import 'package:farmer_alert/view/profile_page.dart';
import 'package:farmer_alert/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigationLayout extends StatefulWidget {
  final int currentIndex;
  final Widget body;

  const BottomNavigationLayout({
    super.key,
    required this.currentIndex,
    required this.body,
  });

  @override
  State<BottomNavigationLayout> createState() => _BottomNavigationLayoutState();
}

class _BottomNavigationLayoutState extends State<BottomNavigationLayout> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ProfilePage()));
          break;
        case 1:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePage()));
          break;
        case 2:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsPage()));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.body,
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Settings"),
            selectedColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
