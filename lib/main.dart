import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/theme/app_theme.dart';
import 'features/library/screens/library_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // Note: You'll need to run `flutterfire configure` to generate firebase_options.dart
  try {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
  } catch (e) {
    debugPrint('Firebase initialization skipped: $e');
    debugPrint('Run: flutterfire configure');
  }

  runApp(
    const ProviderScope(
      child: BooksTrackerApp(),
    ),
  );
}

class BooksTrackerApp extends StatelessWidget {
  const BooksTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books Tracker',
      debugShowCheckedModeBanner: false,

      // Material Design 3 themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Start with Library screen
      home: const LibraryScreen(),
    );
  }
}
