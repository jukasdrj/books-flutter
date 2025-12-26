# 03 - ISBN Scanner Feature Implementation

**Priority:** P0 - Core Feature
**Estimated Effort:** 1 day
**Prerequisites:** 01-CRITICAL-FIXES.md, 02-SEARCH-FEATURE.md
**PRD Reference:** `product/Mobile-Scanner-PRD-Flutter.md`

---

## Overview

The ISBN Scanner enables users to scan book barcodes using their device camera for quick book lookup and library additions. Uses `mobile_scanner` package for cross-platform barcode detection.

---

## Current State

| Component | Status | Notes |
|-----------|--------|-------|
| `mobile_scanner` | In pubspec | Package added, not integrated |
| Scanner Screen | Placeholder | Shows "Coming soon" message |
| Permission Handling | Missing | No camera permission flow |
| ISBN Validation | Missing | No checksum validation |

---

## Target State

```
ISBNScannerScreen
├── MobileScanner (full screen camera preview)
├── ScannerOverlay
│   ├── Semi-transparent scrim
│   ├── Scan area cutout
│   ├── Instructions text
│   └── Torch toggle
├── Close button (AppBar or overlay)
└── Permission denied fallback
```

---

## Implementation Plan

### Step 1: Create ISBN Validator Utility

**File:** `lib/core/utils/isbn_validator.dart`

```dart
/// Validates and normalizes ISBN-10 and ISBN-13 barcodes.
///
/// Follows Dart linting standards with documentation.
class ISBNValidator {
  ISBNValidator._();

  /// Validates an ISBN string and returns true if valid.
  ///
  /// Supports both ISBN-10 and ISBN-13 formats.
  /// Strips hyphens and spaces before validation.
  static bool validate(String? isbn) {
    if (isbn == null || isbn.isEmpty) return false;

    final cleaned = isbn.replaceAll(RegExp(r'[-\s]'), '');

    if (cleaned.length == 10) {
      return _validateISBN10(cleaned);
    } else if (cleaned.length == 13) {
      return _validateISBN13(cleaned);
    }

    return false;
  }

  /// Normalizes ISBN to 13-digit format.
  ///
  /// Returns null if ISBN is invalid.
  static String? normalize(String? isbn) {
    if (!validate(isbn)) return null;

    final cleaned = isbn!.replaceAll(RegExp(r'[-\s]'), '');

    if (cleaned.length == 13) return cleaned;

    // Convert ISBN-10 to ISBN-13
    final prefix = '978${cleaned.substring(0, 9)}';
    final checkDigit = _calculateISBN13CheckDigit(prefix);
    return '$prefix$checkDigit';
  }

  static bool _validateISBN10(String isbn) {
    if (!RegExp(r'^[0-9]{9}[0-9X]$').hasMatch(isbn)) return false;

    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += int.parse(isbn[i]) * (10 - i);
    }

    final lastChar = isbn[9];
    final lastDigit = lastChar == 'X' ? 10 : int.parse(lastChar);
    sum += lastDigit;

    return sum % 11 == 0;
  }

  static bool _validateISBN13(String isbn) {
    if (!RegExp(r'^[0-9]{13}$').hasMatch(isbn)) return false;

    // Must start with 978 or 979 for books
    if (!isbn.startsWith('978') && !isbn.startsWith('979')) return false;

    var sum = 0;
    for (var i = 0; i < 13; i++) {
      final digit = int.parse(isbn[i]);
      sum += (i.isEven) ? digit : digit * 3;
    }

    return sum % 10 == 0;
  }

  static int _calculateISBN13CheckDigit(String prefix) {
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      final digit = int.parse(prefix[i]);
      sum += (i.isEven) ? digit : digit * 3;
    }
    final remainder = sum % 10;
    return remainder == 0 ? 0 : 10 - remainder;
  }
}
```

---

### Step 2: Create Scanner Screen

**File:** `lib/features/search/screens/isbn_scanner_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/utils/isbn_validator.dart';
import '../providers/search_provider.dart';
import '../widgets/scanner_overlay.dart';

/// Screen for scanning ISBN barcodes using the device camera.
///
/// Navigates back with the scanned ISBN or triggers a search directly.
class ISBNScannerScreen extends ConsumerStatefulWidget {
  /// Callback when an ISBN is scanned successfully.
  final void Function(String isbn)? onScanned;

  const ISBNScannerScreen({
    super.key,
    this.onScanned,
  });

  @override
  ConsumerState<ISBNScannerScreen> createState() => _ISBNScannerScreenState();
}

class _ISBNScannerScreenState extends ConsumerState<ISBNScannerScreen> {
  late final MobileScannerController _controller;
  bool _hasScanned = false;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      formats: [
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.upcE,
      ],
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return _buildErrorState(error);
            },
          ),

          // Overlay UI
          ScannerOverlay(
            isTorchOn: _isTorchOn,
            onTorchToggle: _toggleTorch,
            onClose: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    // Prevent multiple scans
    if (_hasScanned) return;

    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue == null) continue;

      // Validate ISBN
      if (ISBNValidator.validate(rawValue)) {
        _hasScanned = true;

        // Haptic feedback
        HapticFeedback.mediumImpact();

        // Normalize to ISBN-13
        final normalizedISBN = ISBNValidator.normalize(rawValue)!;

        if (widget.onScanned != null) {
          widget.onScanned!(normalizedISBN);
        } else {
          // Trigger search and pop
          ref.read(searchNotifierProvider.notifier).searchByISBN(normalizedISBN);
          Navigator.of(context).pop();
        }
        break;
      }
    }
  }

  void _toggleTorch() async {
    await _controller.toggleTorch();
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  Widget _buildErrorState(MobileScannerException error) {
    final message = switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied =>
        'Camera permission denied. Please enable in Settings.',
      MobileScannerErrorCode.unsupported =>
        'This device does not support barcode scanning.',
      _ => 'Camera error: ${error.errorDetails?.message ?? 'Unknown'}',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Step 3: Create Scanner Overlay Widget

**File:** `lib/features/search/widgets/scanner_overlay.dart`

```dart
import 'package:flutter/material.dart';

/// Overlay UI for the barcode scanner with scan area cutout.
class ScannerOverlay extends StatelessWidget {
  /// Whether the torch is currently on.
  final bool isTorchOn;

  /// Callback when torch toggle is pressed.
  final VoidCallback onTorchToggle;

  /// Callback when close button is pressed.
  final VoidCallback onClose;

  const ScannerOverlay({
    super.key,
    required this.isTorchOn,
    required this.onTorchToggle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Semi-transparent scrim with cutout
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _ScannerOverlayPainter(),
          ),

          // Close button
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              color: Colors.white,
              iconSize: 28,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black38,
              ),
            ),
          ),

          // Instructions and torch
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Point camera at ISBN barcode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                IconButton(
                  onPressed: onTorchToggle,
                  icon: Icon(
                    isTorchOn ? Icons.flash_on : Icons.flash_off,
                  ),
                  color: Colors.white,
                  iconSize: 32,
                  style: IconButton.styleFrom(
                    backgroundColor: isTorchOn
                        ? Colors.amber.withOpacity(0.8)
                        : Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6);

    // Calculate scan area (centered, 80% width, 25% height)
    final scanWidth = size.width * 0.8;
    final scanHeight = size.height * 0.25;
    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2 - 50),
      width: scanWidth,
      height: scanHeight,
    );

    // Draw scrim with cutout
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Draw scan area border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, const Radius.circular(16)),
      borderPaint,
    );

    // Draw corner accents
    _drawCornerAccents(canvas, scanRect);
  }

  void _drawCornerAccents(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const length = 32.0;
    const radius = 16.0;

    // Top-left
    canvas.drawLine(
      Offset(rect.left, rect.top + radius + length),
      Offset(rect.left, rect.top + radius),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left + radius, rect.top),
      Offset(rect.left + radius + length, rect.top),
      paint,
    );

    // Top-right
    canvas.drawLine(
      Offset(rect.right, rect.top + radius + length),
      Offset(rect.right, rect.top + radius),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right - radius, rect.top),
      Offset(rect.right - radius - length, rect.top),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(rect.left, rect.bottom - radius - length),
      Offset(rect.left, rect.bottom - radius),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left + radius, rect.bottom),
      Offset(rect.left + radius + length, rect.bottom),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(rect.right, rect.bottom - radius - length),
      Offset(rect.right, rect.bottom - radius),
      paint,
    );
    canvas.drawLine(
      Offset(rect.right - radius, rect.bottom),
      Offset(rect.right - radius - length, rect.bottom),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

---

### Step 4: Integrate with Search Screen

Update search screen FAB to launch scanner:

```dart
// In SearchScreen
void _openBarcodeScanner() {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => const ISBNScannerScreen(),
    ),
  );
}
```

---

### Step 5: Platform Configuration

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
    <!-- ... -->
</manifest>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required to scan book barcodes</string>
```

---

## Linting & Code Quality

### Analysis Options

Ensure `analysis_options.yaml` includes:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_locals
    - avoid_print
    - require_trailing_commas
    - prefer_single_quotes

analyzer:
  errors:
    missing_required_param: error
    missing_return: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

### Code Style Checklist

- [x] All public APIs have dartdoc comments
- [x] Private methods prefixed with underscore
- [x] Const constructors where applicable
- [x] Final fields where possible
- [x] Trailing commas for better diffs
- [x] Single quotes for strings

---

## Testing Strategy

### Unit Tests

**File:** `test/core/utils/isbn_validator_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:books_tracker/core/utils/isbn_validator.dart';

void main() {
  group('ISBNValidator', () {
    group('validate', () {
      test('returns true for valid ISBN-13', () {
        expect(ISBNValidator.validate('9780141036144'), isTrue);
        expect(ISBNValidator.validate('978-0-14-103614-4'), isTrue);
      });

      test('returns true for valid ISBN-10', () {
        expect(ISBNValidator.validate('0141036141'), isTrue);
        expect(ISBNValidator.validate('0-14-103614-1'), isTrue);
      });

      test('returns true for ISBN-10 with X check digit', () {
        expect(ISBNValidator.validate('080442957X'), isTrue);
      });

      test('returns false for invalid ISBN', () {
        expect(ISBNValidator.validate('1234567890123'), isFalse);
        expect(ISBNValidator.validate('0000000000'), isFalse);
        expect(ISBNValidator.validate(''), isFalse);
        expect(ISBNValidator.validate(null), isFalse);
      });

      test('returns false for non-book EAN-13', () {
        expect(ISBNValidator.validate('5901234123457'), isFalse);
      });
    });

    group('normalize', () {
      test('converts ISBN-10 to ISBN-13', () {
        expect(ISBNValidator.normalize('0141036141'), equals('9780141036144'));
      });

      test('returns ISBN-13 unchanged', () {
        expect(ISBNValidator.normalize('9780141036144'), equals('9780141036144'));
      });

      test('returns null for invalid ISBN', () {
        expect(ISBNValidator.normalize('invalid'), isNull);
      });
    });
  });
}
```

### Widget Tests

**File:** `test/features/search/screens/isbn_scanner_screen_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:books_tracker/features/search/widgets/scanner_overlay.dart';

void main() {
  group('ScannerOverlay', () {
    testWidgets('renders instructions text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScannerOverlay(
              isTorchOn: false,
              onTorchToggle: () {},
              onClose: () {},
            ),
          ),
        ),
      );

      expect(find.text('Point camera at ISBN barcode'), findsOneWidget);
    });

    testWidgets('close button triggers callback', (tester) async {
      var closeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScannerOverlay(
              isTorchOn: false,
              onTorchToggle: () {},
              onClose: () => closeCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      expect(closeCalled, isTrue);
    });

    testWidgets('torch toggle shows correct icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScannerOverlay(
              isTorchOn: false,
              onTorchToggle: () {},
              onClose: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.flash_off), findsOneWidget);
      expect(find.byIcon(Icons.flash_on), findsNothing);
    });
  });
}
```

### Integration Test Notes

Real barcode scanning requires physical device testing:
- Use `integration_test/` folder
- Mock `MobileScannerController` for UI testing
- Test actual scanning on real devices during QA

---

## Files to Create

| File | Type | Description |
|------|------|-------------|
| `lib/core/utils/isbn_validator.dart` | Utility | ISBN validation and normalization |
| `lib/features/search/screens/isbn_scanner_screen.dart` | Screen | Camera scanner UI |
| `lib/features/search/widgets/scanner_overlay.dart` | Widget | Scanner overlay with cutout |
| `test/core/utils/isbn_validator_test.dart` | Test | ISBN validation tests |
| `test/features/search/widgets/scanner_overlay_test.dart` | Test | Overlay widget tests |

---

## Files to Modify

| File | Change |
|------|--------|
| `lib/features/search/screens/search_screen.dart` | Add FAB navigation |
| `lib/features/search/search.dart` | Export scanner screen |
| `android/app/src/main/AndroidManifest.xml` | Add camera permission |
| `ios/Runner/Info.plist` | Add camera usage description |

---

## Next Steps

After implementing Scanner:
1. **04-BOOKSHELF-SCANNER.md** - AI-powered bookshelf photo scanning
2. Test on physical iOS and Android devices

---

**Document Status:** Ready for Implementation
**Last Updated:** December 26, 2025
