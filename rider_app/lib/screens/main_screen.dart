import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'deliver_screen.dart';
import 'pickup_screen.dart';
import 'settings_screen.dart';
import '../bloc/assignments/assignments_bloc.dart';
import '../bloc/location/location_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _locationTrackingStarted = false;

  final List<Widget> _screens = [
    const DeliverScreen(),
    const PickupScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Start location tracking automatically when rider logs in
    // This ensures riders appear on the office map even without active packages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_locationTrackingStarted) {
        debugPrint('MainScreen: Starting location tracking...');
        try {
          final locationBloc = context.read<LocationBloc>();
          // Start location tracking without a package_id (general tracking)
          locationBloc.add(const LocationEvent.start(packageId: null));
          _locationTrackingStarted = true;
          debugPrint('MainScreen: Location tracking event dispatched');
        } catch (e) {
          debugPrint('MainScreen: Error starting location tracking: $e');
        }
      }
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Refetch assignments when switching to Deliver or Pickup tabs
    // This ensures fresh data when navigating between tabs
    if (index == 0 || index == 1) {
      // Refetch when switching to Deliver (0) or Pickup (1) tabs
      // This includes switching from Settings back to Deliver/Pickup
      context.read<AssignmentsBloc>().add(
        const AssignmentsEvent.fetchRequested(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Deliver',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Pickup'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
