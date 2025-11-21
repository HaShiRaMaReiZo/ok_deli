import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      appBar: AppBar(
        title: const Text('Track'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          'Track Packages\nComing Soon',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
