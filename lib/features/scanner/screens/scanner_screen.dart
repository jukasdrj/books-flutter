import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Scanner Screen - AI-powered bookshelf scanner
/// Mobile: Camera-based AI detection with Gemini 2.0 Flash
/// Web: Fallback to file upload
class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                kIsWeb ? Icons.upload_file : Icons.camera_alt,
                size: 80,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                kIsWeb ? 'Upload Bookshelf Photo' : 'AI Bookshelf Scanner',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                kIsWeb
                    ? 'Coming soon: Upload photos of your bookshelf for AI detection'
                    : 'Coming soon: Photograph your bookshelf to automatically detect books',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (!kIsWeb)
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Barcode'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
