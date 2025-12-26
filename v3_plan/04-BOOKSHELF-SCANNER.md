# 04 - Bookshelf Scanner (AI Detection)

**Priority:** P1 - Key Differentiator
**Estimated Effort:** 3-4 days
**Prerequisites:** 01-CRITICAL-FIXES.md, 03-SCANNER-FEATURE.md
**PRD Reference:** `product/Bookshelf-Scanner-PRD-Flutter.md`

---

## Overview

The Bookshelf Scanner uses Gemini 2.0 Flash AI to detect books from photographs of physical bookshelves. Users photograph their shelves, the AI identifies book titles and authors, and detected books are added to the library with optional human review for low-confidence detections.

---

## Current State

| Component | Status | Notes |
|-----------|--------|-------|
| ScanSessions table | Complete | Database schema ready |
| DetectedItems table | Complete | Database schema ready |
| Camera package | In pubspec | Package added, not integrated |
| API endpoint | Backend ready | `/api/scan-bookshelf` available |
| WebSocket progress | Backend ready | `/ws/progress` available |
| Flutter implementation | Stub only | Empty feature folder |

---

## Target Architecture

```
BookshelfScannerScreen
├── CameraPreview
│   ├── Full screen viewfinder
│   ├── Capture button (FAB)
│   └── Flash toggle
├── PhotoReviewSheet
│   ├── Captured image preview
│   ├── "Use Photo" / "Retake" buttons
│   └── Quality tips
├── ProcessingScreen
│   ├── Progress indicator
│   ├── Status text ("Processing with AI...")
│   ├── Detected count updates
│   └── Cancel button
└── ScanResultsScreen
    ├── Detected books list
    ├── Confidence indicators
    ├── "Add All" button
    └── Review queue badge
```

---

## Implementation Plan

### Step 1: Create Camera Manager Service

**File:** `lib/features/bookshelf_scanner/services/camera_manager.dart`

```dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Manages camera lifecycle for bookshelf scanning.
///
/// Handles initialization, capture, and disposal of camera resources.
class CameraManager {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  /// Whether the camera is initialized and ready.
  bool get isInitialized => _isInitialized;

  /// The camera controller for the preview widget.
  CameraController? get controller => _controller;

  /// Initializes the camera with back-facing lens.
  ///
  /// Throws [CameraException] if no cameras available.
  Future<void> initialize() async {
    _cameras = await availableCameras();

    if (_cameras == null || _cameras!.isEmpty) {
      throw CameraException('noCameras', 'No cameras available on device');
    }

    final backCamera = _cameras!.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras!.first,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
    _isInitialized = true;
  }

  /// Captures a photo and returns the file path.
  ///
  /// Images are saved to temporary directory with UUID filename.
  Future<String> capturePhoto() async {
    if (!_isInitialized || _controller == null) {
      throw StateError('Camera not initialized');
    }

    final XFile image = await _controller!.takePicture();

    // Move to app temp directory with unique name
    final tempDir = await getTemporaryDirectory();
    final fileName = '${const Uuid().v4()}.jpg';
    final targetPath = '${tempDir.path}/$fileName';

    await File(image.path).copy(targetPath);

    return targetPath;
  }

  /// Toggles the flash mode between off and torch.
  Future<void> toggleFlash() async {
    if (_controller == null) return;

    final currentMode = _controller!.value.flashMode;
    final newMode = currentMode == FlashMode.off
        ? FlashMode.torch
        : FlashMode.off;

    await _controller!.setFlashMode(newMode);
  }

  /// Returns current flash mode.
  FlashMode? get flashMode => _controller?.value.flashMode;

  /// Disposes camera resources.
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }
}
```

---

### Step 2: Create Bookshelf AI Service

**File:** `lib/core/services/api/bookshelf_ai_service.dart`

```dart
import 'dart:io';
import 'package:dio/dio.dart';

/// Service for uploading bookshelf images and receiving AI detections.
class BookshelfAIService {
  final Dio _dio;

  BookshelfAIService(this._dio);

  /// Uploads a single bookshelf image for AI processing.
  ///
  /// Returns the job ID for WebSocket progress tracking.
  Future<String> uploadImage({
    required String imagePath,
    required String jobId,
  }) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw ArgumentError('Image file not found: $imagePath');
    }

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imagePath,
        filename: 'bookshelf.jpg',
      ),
    });

    await _dio.post(
      '/api/scan-bookshelf',
      data: formData,
      queryParameters: {'jobId': jobId},
      options: Options(
        contentType: 'multipart/form-data',
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    return jobId;
  }

  /// Uploads multiple bookshelf images for batch processing.
  Future<String> uploadBatch({
    required List<String> imagePaths,
    required String jobId,
  }) async {
    final files = <MapEntry<String, MultipartFile>>[];

    for (var i = 0; i < imagePaths.length; i++) {
      files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(
          imagePaths[i],
          filename: 'bookshelf_$i.jpg',
        ),
      ));
    }

    final formData = FormData.fromMap({});
    formData.files.addAll(files);

    await _dio.post(
      '/api/scan-bookshelf/batch',
      data: formData,
      queryParameters: {'jobId': jobId},
      options: Options(
        contentType: 'multipart/form-data',
        receiveTimeout: const Duration(seconds: 300),
      ),
    );

    return jobId;
  }

  /// Cancels an in-flight scan job.
  Future<void> cancelJob(String jobId) async {
    await _dio.post(
      '/api/enrichment/cancel',
      data: {'jobId': jobId},
    );
  }
}
```

---

### Step 3: Create WebSocket Progress Manager

**File:** `lib/core/services/websocket/progress_manager.dart`

```dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Progress update from the backend during AI processing.
class ProgressUpdate {
  final double progress;
  final String status;
  final int processedItems;
  final int totalItems;
  final bool isComplete;
  final bool isCanceled;
  final List<DetectedBookData>? detectedBooks;

  const ProgressUpdate({
    required this.progress,
    required this.status,
    required this.processedItems,
    required this.totalItems,
    this.isComplete = false,
    this.isCanceled = false,
    this.detectedBooks,
  });

  factory ProgressUpdate.fromJson(Map<String, dynamic> json) {
    return ProgressUpdate(
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      status: json['currentStatus'] as String? ?? '',
      processedItems: json['processedItems'] as int? ?? 0,
      totalItems: json['totalItems'] as int? ?? 0,
      isComplete: json['type'] == 'complete',
      isCanceled: json['canceled'] as bool? ?? false,
      detectedBooks: json['detectedBooks'] != null
          ? (json['detectedBooks'] as List)
              .map((b) => DetectedBookData.fromJson(b as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

/// Data for a single detected book from AI.
class DetectedBookData {
  final String title;
  final String author;
  final double confidence;
  final Map<String, double>? boundingBox;
  final String? coverUrl;
  final String? enrichmentStatus;

  const DetectedBookData({
    required this.title,
    required this.author,
    required this.confidence,
    this.boundingBox,
    this.coverUrl,
    this.enrichmentStatus,
  });

  factory DetectedBookData.fromJson(Map<String, dynamic> json) {
    return DetectedBookData(
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
      boundingBox: json['boundingBox'] != null
          ? Map<String, double>.from(json['boundingBox'] as Map)
          : null,
      coverUrl: json['coverUrl'] as String?,
      enrichmentStatus: json['enrichmentStatus'] as String?,
    );
  }
}

/// Manages WebSocket connection for real-time progress updates.
class ProgressManager {
  // TODO: Externalize WebSocket URL to configuration
  static const String _baseUrl = 'wss://api.oooefam.net/ws/progress';

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  /// Stream of progress updates.
  Stream<ProgressUpdate> connect(String jobId) {
    final controller = StreamController<ProgressUpdate>();

    _channel = WebSocketChannel.connect(
      Uri.parse('$_baseUrl?jobId=$jobId'),
    );

    _subscription = _channel!.stream.listen(
      (data) {
        try {
          final json = jsonDecode(data as String) as Map<String, dynamic>;

          // Skip keep-alive pings
          if (json['keepAlive'] == true) return;

          final update = ProgressUpdate.fromJson(json);
          controller.add(update);

          // Close on completion
          if (update.isComplete || update.isCanceled) {
            controller.close();
            disconnect();
          }
        } catch (e) {
          controller.addError(e);
        }
      },
      onError: (Object error) {
        controller.addError(error);
        controller.close();
      },
      onDone: () {
        controller.close();
      },
    );

    return controller.stream;
  }

  /// Disconnects the WebSocket.
  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }
}
```

---

### Step 4: Create Scan State Provider

**File:** `lib/features/bookshelf_scanner/providers/scan_state_provider.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/api/bookshelf_ai_service.dart';
import '../../../core/services/websocket/progress_manager.dart';
import '../../../core/providers/api_client_provider.dart';

part 'scan_state_provider.g.dart';

/// State of the bookshelf scanning process.
sealed class ScanState {
  const ScanState();
}

class ScanStateIdle extends ScanState {
  const ScanStateIdle();
}

class ScanStateCapturing extends ScanState {
  const ScanStateCapturing();
}

class ScanStateUploading extends ScanState {
  final String imagePath;
  const ScanStateUploading(this.imagePath);
}

class ScanStateProcessing extends ScanState {
  final String jobId;
  final double progress;
  final String status;
  final int processedItems;
  final int totalItems;

  const ScanStateProcessing({
    required this.jobId,
    required this.progress,
    required this.status,
    required this.processedItems,
    required this.totalItems,
  });
}

class ScanStateComplete extends ScanState {
  final List<DetectedBookData> detectedBooks;
  final int reviewQueueCount;

  const ScanStateComplete({
    required this.detectedBooks,
    required this.reviewQueueCount,
  });

  int get verifiedCount =>
      detectedBooks.where((b) => b.confidence >= 0.6).length;
}

class ScanStateError extends ScanState {
  final String message;
  const ScanStateError(this.message);
}

class ScanStateCanceled extends ScanState {
  const ScanStateCanceled();
}

@riverpod
class ScanNotifier extends _$ScanNotifier {
  String? _currentJobId;
  ProgressManager? _progressManager;

  @override
  ScanState build() => const ScanStateIdle();

  /// Starts scanning with the captured image.
  Future<void> startScan(String imagePath) async {
    state = ScanStateUploading(imagePath);

    try {
      _currentJobId = const Uuid().v4();
      final dio = ref.read(apiClientProvider);
      final aiService = BookshelfAIService(dio);

      // Upload image
      await aiService.uploadImage(
        imagePath: imagePath,
        jobId: _currentJobId!,
      );

      // Connect to WebSocket for progress
      _progressManager = ProgressManager();
      final progressStream = _progressManager!.connect(_currentJobId!);

      state = ScanStateProcessing(
        jobId: _currentJobId!,
        progress: 0,
        status: 'Starting AI analysis...',
        processedItems: 0,
        totalItems: 0,
      );

      await for (final update in progressStream) {
        if (update.isComplete) {
          final detectedBooks = update.detectedBooks ?? [];
          final reviewCount = detectedBooks.where((b) => b.confidence < 0.6).length;

          state = ScanStateComplete(
            detectedBooks: detectedBooks,
            reviewQueueCount: reviewCount,
          );
          break;
        } else if (update.isCanceled) {
          state = const ScanStateCanceled();
          break;
        } else {
          state = ScanStateProcessing(
            jobId: _currentJobId!,
            progress: update.progress,
            status: update.status,
            processedItems: update.processedItems,
            totalItems: update.totalItems,
          );
        }
      }
    } catch (e) {
      state = ScanStateError(e.toString());
    }
  }

  /// Cancels the current scan.
  Future<void> cancelScan() async {
    if (_currentJobId == null) return;

    try {
      final dio = ref.read(apiClientProvider);
      final aiService = BookshelfAIService(dio);
      await aiService.cancelJob(_currentJobId!);

      _progressManager?.disconnect();
      state = const ScanStateCanceled();
    } catch (e) {
      // Best effort cancel
      state = const ScanStateCanceled();
    }
  }

  /// Resets to idle state for new scan.
  void reset() {
    _progressManager?.disconnect();
    _currentJobId = null;
    state = const ScanStateIdle();
  }
}
```

---

### Step 5: Create Bookshelf Scanner Screen

**File:** `lib/features/bookshelf_scanner/screens/bookshelf_scanner_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../providers/scan_state_provider.dart';
import '../services/camera_manager.dart';
import 'scan_results_screen.dart';

/// Main screen for AI-powered bookshelf scanning.
class BookshelfScannerScreen extends ConsumerStatefulWidget {
  const BookshelfScannerScreen({super.key});

  @override
  ConsumerState<BookshelfScannerScreen> createState() =>
      _BookshelfScannerScreenState();
}

class _BookshelfScannerScreenState
    extends ConsumerState<BookshelfScannerScreen> {
  final CameraManager _cameraManager = CameraManager();
  bool _isInitializing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraManager.initialize();
      setState(() => _isInitializing = false);
    } catch (e) {
      setState(() {
        _isInitializing = false;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _cameraManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanNotifierProvider);

    // Handle state transitions
    ref.listen<ScanState>(scanNotifierProvider, (previous, next) {
      if (next is ScanStateComplete) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (context) => ScanResultsScreen(
              detectedBooks: next.detectedBooks,
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Scan Bookshelf'),
      ),
      body: _buildBody(scanState),
    );
  }

  Widget _buildBody(ScanState scanState) {
    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_error != null) {
      return _buildErrorState(_error!);
    }

    return switch (scanState) {
      ScanStateIdle() || ScanStateCapturing() => _buildCameraView(),
      ScanStateUploading() => _buildUploadingState(),
      ScanStateProcessing(:final progress, :final status) =>
        _buildProcessingState(progress, status),
      ScanStateError(:final message) => _buildErrorState(message),
      ScanStateCanceled() => _buildCanceledState(),
      ScanStateComplete() => const SizedBox.shrink(), // Handled by listener
    };
  }

  Widget _buildCameraView() {
    if (_cameraManager.controller == null) {
      return const Center(child: Text('Camera unavailable'));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraManager.controller!),

        // Instructions
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Position your bookshelf in frame. Ensure good lighting and readable spines.',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Capture button
        Positioned(
          bottom: 48,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton.large(
              onPressed: _capturePhoto,
              child: const Icon(Icons.camera),
            ),
          ),
        ),

        // Flash toggle
        Positioned(
          bottom: 64,
          right: 24,
          child: IconButton(
            onPressed: _toggleFlash,
            icon: Icon(
              _cameraManager.flashMode == FlashMode.torch
                  ? Icons.flash_on
                  : Icons.flash_off,
            ),
            color: Colors.white,
            iconSize: 32,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingState(double progress, String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: progress > 0 ? progress : null,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            status,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (progress > 0)
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(color: Colors.white70),
            ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              ref.read(scanNotifierProvider.notifier).cancelScan();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Uploading photo...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ref.read(scanNotifierProvider.notifier).reset();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildCanceledState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cancel_outlined, size: 64, color: Colors.orange),
          const SizedBox(height: 16),
          const Text(
            'Scan canceled',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ref.read(scanNotifierProvider.notifier).reset();
            },
            child: const Text('Start New Scan'),
          ),
        ],
      ),
    );
  }

  Future<void> _capturePhoto() async {
    try {
      final imagePath = await _cameraManager.capturePhoto();
      ref.read(scanNotifierProvider.notifier).startScan(imagePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture: $e')),
      );
    }
  }

  void _toggleFlash() {
    _cameraManager.toggleFlash();
    setState(() {});
  }
}
```

---

### Step 6: Create Scan Results Screen

**File:** `lib/features/bookshelf_scanner/screens/scan_results_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/websocket/progress_manager.dart';

/// Displays detected books from AI scan with confidence indicators.
class ScanResultsScreen extends ConsumerWidget {
  final List<DetectedBookData> detectedBooks;

  const ScanResultsScreen({
    super.key,
    required this.detectedBooks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verifiedBooks = detectedBooks.where((b) => b.confidence >= 0.6).toList();
    final reviewBooks = detectedBooks.where((b) => b.confidence < 0.6).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${detectedBooks.length} Books Detected'),
      ),
      body: Column(
        children: [
          // Summary card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        label: 'Verified',
                        value: verifiedBooks.length.toString(),
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        label: 'Needs Review',
                        value: reviewBooks.length.toString(),
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Books list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: detectedBooks.length,
              itemBuilder: (context, index) {
                final book = detectedBooks[index];
                return _DetectedBookCard(book: book);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: () => _addAllToLibrary(context, ref),
                  child: const Text('Add All to Library'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addAllToLibrary(BuildContext context, WidgetRef ref) {
    // Implementation: Save detected books to database
    // High confidence → verified status
    // Low confidence → needsReview status

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${detectedBooks.length} books to library'),
      ),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _DetectedBookCard extends StatelessWidget {
  final DetectedBookData book;

  const _DetectedBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final isHighConfidence = book.confidence >= 0.6;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: book.coverUrl != null
            ? Image.network(book.coverUrl!, width: 40)
            : const Icon(Icons.book),
        title: Text(book.title),
        subtitle: Text(book.author),
        trailing: Chip(
          label: Text('${(book.confidence * 100).toInt()}%'),
          backgroundColor: isHighConfidence ? Colors.green[100] : Colors.orange[100],
          labelStyle: TextStyle(
            color: isHighConfidence ? Colors.green[800] : Colors.orange[800],
          ),
        ),
      ),
    );
  }
}
```

---

## Testing Strategy

### Unit Tests

- [ ] CameraManager initialization and capture
- [ ] BookshelfAIService upload and cancel
- [ ] ProgressManager WebSocket message parsing
- [ ] ScanNotifier state transitions

### Widget Tests

- [ ] BookshelfScannerScreen renders camera preview
- [ ] Processing state shows progress indicator
- [ ] ScanResultsScreen displays detected books
- [ ] Confidence indicators show correct colors

### Integration Tests

- [ ] Full flow: Capture → Upload → WebSocket → Results
- [ ] Cancel mid-processing → State updates correctly
- [ ] Add to library → Database updated

---

## Files to Create

| File | Type | Description |
|------|------|-------------|
| `lib/features/bookshelf_scanner/services/camera_manager.dart` | Service | Camera lifecycle |
| `lib/core/services/api/bookshelf_ai_service.dart` | Service | API upload |
| `lib/core/services/websocket/progress_manager.dart` | Service | WebSocket progress |
| `lib/features/bookshelf_scanner/providers/scan_state_provider.dart` | Provider | Scan state |
| `lib/features/bookshelf_scanner/screens/bookshelf_scanner_screen.dart` | Screen | Main scanner |
| `lib/features/bookshelf_scanner/screens/scan_results_screen.dart` | Screen | Results display |

---

## Next Steps

After implementing Bookshelf Scanner:
1. **05-REVIEW-QUEUE.md** - Handle low-confidence detections
2. Test with physical devices and various bookshelf configurations

---

**Document Status:** Ready for Implementation
**Last Updated:** December 26, 2025
