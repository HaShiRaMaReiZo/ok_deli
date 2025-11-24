import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../models/user_model.dart';
import 'home/home_screen.dart';
import 'draft/draft_screen.dart';
import 'track/track_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final UserModel user;
  final Future<void> Function(String)? onLanguageChanged;

  const MainNavigationScreen({
    super.key,
    required this.user,
    this.onLanguageChanged,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(user: widget.user),
      const DraftScreen(),
      const TrackScreen(),
      ProfileScreen(
        user: widget.user,
        onLanguageChanged: widget.onLanguageChanged,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.darkBlue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.drafts_outlined),
            activeIcon: const Icon(Icons.drafts),
            label: AppLocalizations.of(context)!.draft,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.track_changes_outlined),
            activeIcon: const Icon(Icons.track_changes),
            label: AppLocalizations.of(context)!.track,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
    );
  }
}
