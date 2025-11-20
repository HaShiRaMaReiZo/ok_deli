import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.title,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon ?? Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              title ?? 'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatErrorMessage(message),
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatErrorMessage(String error) {
    // Format common error messages to be more user-friendly
    if (error.contains('SocketException') ||
        error.contains('Failed host lookup')) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (error.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    if (error.contains('401') || error.contains('Unauthorized')) {
      return 'Authentication failed. Please login again.';
    }
    if (error.contains('403') || error.contains('Forbidden')) {
      return 'You don\'t have permission to perform this action.';
    }
    if (error.contains('404') || error.contains('Not Found')) {
      return 'The requested resource was not found.';
    }
    if (error.contains('500') || error.contains('Internal Server Error')) {
      return 'Server error. Please try again later.';
    }
    if (error.contains('422') || error.contains('Unprocessable')) {
      return 'Invalid data. Please check your input and try again.';
    }
    // Return original message if no match
    return error;
  }
}
