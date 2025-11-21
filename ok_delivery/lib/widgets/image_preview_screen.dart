import 'package:flutter/material.dart';

/// Reusable image preview screen that can be used throughout the project
class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;
  final String? title;

  const ImagePreviewScreen({super.key, required this.imageUrl, this.title});

  /// Static method to easily navigate to image preview
  static void show(BuildContext context, String imageUrl, {String? title}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ImagePreviewScreen(imageUrl: imageUrl, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: title != null
            ? Text(title!, style: const TextStyle(color: Colors.white))
            : null,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
