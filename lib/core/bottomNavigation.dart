import 'package:flutter/material.dart';
import 'package:flutter_wormhole/features/home/home.dart';

import '../features/critical_vehicles/critical_vehicles.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentPageIndex = 0;

  void navigate(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (c) {
      switch (currentPageIndex) {
        case 0:
          return const HomePage();
          case 1:
          return const CriticalVehicles();
        default:
          return const HomePage();
      }
    }));
  }

  @override
  Widget build(BuildContext ctx) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
          navigate(ctx);
        });
      },
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.car_crash),
          label: 'Critical Vehicles',
        ),
      ],
    );
  }
}
