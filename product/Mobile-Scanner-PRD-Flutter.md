# Mobile Scanner - Product Requirements Document

**Feature:** ISBN Barcode Scanning with Mobile Scanner (Flutter)
**Status:** 📝 Draft (Flutter Conversion)
**Last Updated:** November 12, 2025
**Owner:** Flutter Engineering Team
**Target Platform:** iOS and Android
**Related Docs:**
- Workflow: [Barcode Scanner Workflow](../workflows/barcode-scanner-workflow.md)
- Package: [mobile_scanner on pub.dev](https://pub.dev/packages/mobile_scanner)

---

## Problem Statement

**User Pain Point:**
Manually typing 13-digit ISBNs is slow, error-prone, and frustrating. Users want to add books to their library quickly, especially when standing in a bookstore or library with dozens of books to catalog.

**Why Now:**
- Cross-platform barcode scanning is essential for both iOS and Android users
- `mobile_scanner` package provides native performance using platform APIs (Google ML Kit on Android, AVFoundation on iOS)
- Zero custom camera code needed (similar to VisionKit philosophy)
- User feedback: "I want to scan books as fast as I can tap them"

**Previous iOS Implementation:**
- VisionKit (iOS-only) worked well but excluded Android users
- AVFoundation had maintenance burden (200+ lines of camera code)
- Flutter `mobile_scanner` provides cross-platform solution with native performance

---

## Solution Overview

**High-Level Architecture:**
The `mobile_scanner` package (powered by Google ML Kit on Android, AVFoundation on iOS) provides enterprise-grade barcode scanning with minimal code. Built-in UI guidance, tap-to-scan gestures, zoom controls, and automatic error handling.

**Key Technical Choices:**
1. **mobile_scanner over custom camera:** Zero custom camera code, built-in gestures, automatic detection
2. **ISBN-specific symbologies:** EAN-13, EAN-8, UPC-E (book-specific barcodes)
3. **Device capability checking:** Graceful degradation for devices without camera
4. **Permission-aware UI:** Direct link to Settings when camera access denied

**Trade-offs Considered:**
- **Requires camera permission:** Acceptable (standard for barcode apps)
- **Platform-specific behaviors:** Android uses ML Kit, iOS uses AVFoundation under the hood
- **Tap-to-scan vs auto-scan:** Auto-scan on detect for speed, with validation to prevent false positives

**Why This Approach:**
`mobile_scanner` eliminates custom camera code, provides excellent UX (auto-detection, zoom, torch), and works on both iOS and Android. Package maintainers handle platform-specific APIs, we maintain zero lines of camera logic.

---

## User Stories

### Primary Use Cases

**US-1: Quick Book Addition**
As a user browsing a bookstore,
I want to scan book ISBNs with my camera,
So I can add books to my wishlist in <3 seconds per book.

**Acceptance Criteria:**
- Tap "Scan ISBN" button in SearchScreen
- Camera launches with scanner overlay
- Point at barcode - auto-detects and triggers search
- Book details appear within 3 seconds (scan + API fetch)
- Can scan next book immediately (no forced navigation)

**Implementation:** `lib/features/search/screens/isbn_scanner_screen.dart`

---

**US-2: Device Compatibility Awareness**
As a user with a device without a camera,
I want clear messaging when barcode scanning isn't available,
So I understand why the feature doesn't work and what alternatives exist.

**Acceptance Criteria:**
- On devices without camera: Show UnsupportedDeviceScreen with clear explanation
- Message: "This device doesn't support the barcode scanner. Please use a device with a camera."
- Provide fallback: Manual ISBN entry always available in SearchScreen

**Implementation:** Camera capability check before launching scanner

---

**US-3: Camera Permission Handling**
As a user who denied camera access,
I want a direct link to Settings,
So I can enable permissions without hunting through system menus.

**Acceptance Criteria:**
- On permission denial: Show PermissionDeniedScreen with explanation
- "Open Settings" button launches system Settings → App → Permissions
- After enabling, returning to app shows scanner (no restart required)

**Implementation:** `permission_handler` package integration

---

**US-4: Error Recovery**
As a user whose camera becomes unavailable mid-scan (call, low battery, etc.),
I want the scanner to close gracefully,
So I don't get stuck in a broken state.

**Acceptance Criteria:**
- On camera error: Scanner dismisses automatically
- User returns to SearchScreen (last known good state)
- Error logged for debugging: `"Scanner became unavailable: [error]"`
- Can retry scanning after error clears

**Implementation:** MobileScanner `onDetect` error handling

---

### Edge Cases

**US-5: Non-ISBN Barcode Rejection**
As a user accidentally scanning product barcodes,
I want non-ISBN barcodes validated before triggering search,
So I don't get false search results for random products.

**Acceptance Criteria:**
- Scan UPC for shampoo: Validated, rejected if not ISBN format
- Scan EAN-13 ISBN: Triggers search immediately
- Show brief feedback: "Invalid ISBN barcode" (if non-ISBN detected)

**Implementation:** ISBNValidator integration before API call

---

## Success Metrics

### Quantifiable Metrics

**Performance:**
- ✅ **95% of ISBN scans complete in <3s** (scan + API response)
  - Target: mobile_scanner detection <500ms, API avg 800ms
  - Total: <1.5s avg (well under 3s target)

**Reliability:**
- ✅ **Zero crashes from permission denial** (graceful permission handling)
- ✅ **Zero crashes from camera unavailability** (error callback handling)
- ✅ **100% ISBN validation** (ISBNValidator rejects invalid barcodes)

**Adoption:**
- Target: 60% of book additions via barcode (vs manual search)
- Measurement: Analytics events (`barcode_scan_completed`)

### Observable Metrics

**User Experience:**
- ✅ Auto-detection improves first-try success rate (mobile_scanner feature)
- ✅ Haptic feedback confirms successful scan (`HapticFeedback.vibrate()`)
- ✅ Zoom controls help with distant/small barcodes (mobile_scanner feature)
- ✅ Torch toggle for low-light scanning

**Accessibility:**
- ✅ Screen reader support (Semantics widgets for all UI elements)
- ✅ High contrast UI (Material 3 compliant)
- ✅ Large touch targets (Material minimum 48dp)

---

## Technical Implementation

### Flutter Architecture

**Package:** `mobile_scanner ^3.5.0`
**Platforms:** iOS 11.0+, Android 5.0+ (API 21+)
**Hardware Requirement:** Device with camera

**Key Files:**

1. **ISBNScannerScreen** (`lib/features/search/screens/isbn_scanner_screen.dart`)
   - Entry point from SearchScreen
   - Wraps MobileScanner widget
   - Handles permission checks and error states
   - Provides overlay UI (crosshair, instructions, close button)

2. **ScannerOverlayWidget** (`lib/features/search/widgets/scanner_overlay.dart`)
   - Visual overlay showing scan area
   - Instructions text ("Point at ISBN barcode")
   - Torch toggle button
   - Close button

3. **ISBNValidator** (`lib/core/utils/isbn_validator.dart`)
   - Validates ISBN-10 and ISBN-13 format
   - Normalizes to ISBN-13
   - Rejects non-ISBN barcodes

**MobileScanner Configuration:**
```dart
MobileScanner(
  controller: MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    formats: [
      BarcodeFormat.ean13,    // Primary ISBN format
      BarcodeFormat.ean8,     // Short ISBN format
      BarcodeFormat.upcE,     // North American ISBNs
    ],
    facing: CameraFacing.back,
    torchEnabled: false,
  ),
  onDetect: (capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null && ISBNValidator.validate(code)) {
        // Trigger search
        _handleISBNScanned(code);
        break;
      }
    }
  },
)
```

**Integration Points:**
- **SearchScreen:** Shows scanner via navigation or bottom sheet
- **ISBNValidator:** Validates and normalizes ISBN before search
- **BookSearchAPIService:** Fetches book metadata from `/v1/search/isbn?isbn={isbn}`
- **HapticFeedback:** Provides tactile feedback on successful scan

**Dependencies:**
```yaml
dependencies:
  mobile_scanner: ^3.5.0
  permission_handler: ^11.0.0  # For camera permission management
```

**Known Limitations:**
- Requires camera hardware (no emulator support for real scanning)
- Requires camera permission (platform standard)
- Works best with good lighting (physical limitation)
- Can't scan damaged/obscured barcodes (physical limitation)

---

## Design & User Experience

### Material Design 3 Implementation

**Scanner Screen Layout:**
- Full-screen MobileScanner (camera preview)
- Overlay with semi-transparent scrim
- Center cutout showing scan area (crosshair or rectangle)
- Top bar: Close button (IconButton)
- Bottom bar: Instructions text + Torch toggle
- Haptic feedback on successful scan

**Color Scheme:**
- **Overlay scrim:** Black with 60% opacity
- **Scan area:** Transparent with white border (2dp)
- **Instructions:** White text on dark background
- **Buttons:** Material 3 IconButton with white foreground

**Typography:**
- Instructions: `textTheme.bodyLarge` (white color)
- Error messages: `textTheme.bodyMedium` (error color)

**Animations:**
- Scanner overlay fade-in on launch
- Scan area pulsing border (optional)
- Success feedback: Brief green flash

---

## Technical Architecture

### System Components

| Component | Type | Responsibility | File Location |
|-----------|------|---------------|---------------|
| **ISBNScannerScreen** | StatefulWidget | Scanner UI and logic | `lib/features/search/screens/isbn_scanner_screen.dart` |
| **ScannerOverlayWidget** | StatelessWidget | Visual overlay UI | `lib/features/search/widgets/scanner_overlay.dart` |
| **ISBNValidator** | Utility Class | ISBN validation | `lib/core/utils/isbn_validator.dart` |
| **MobileScannerController** | Provider (mobile_scanner) | Camera controller | Package-provided |

---

### Data Models

**No database models needed** - scanned ISBNs immediately trigger search API

**In-Memory State:**
```dart
class ScannerState {
  final bool isTorchEnabled;
  final bool isScanning;
  final String? lastScannedISBN;
  final String? errorMessage;
}
```

---

### Integration Flow

```dart
SearchScreen
  ↓ User taps "Scan ISBN" FAB
Navigator.push(ISBNScannerScreen)
  ↓ Check camera permission
MobileScanner launches (if permission granted)
  ↓ User points at barcode
MobileScanner.onDetect fires
  ↓ Extract barcode.rawValue
ISBNValidator.validate(code)
  ↓ If valid ISBN
BookSearchAPIService.searchByISBN(isbn)
  ↓ API returns book data
Navigator.pop() → Return to SearchScreen with result
  ↓ Display book details
```

---

### Dependencies

**Flutter Packages:**
```yaml
dependencies:
  flutter:
    sdk: flutter

  # Barcode Scanning
  mobile_scanner: ^3.5.0

  # Permissions
  permission_handler: ^11.0.0

  # State Management
  flutter_riverpod: ^2.4.0  # For scanner state

  # Networking
  dio: ^5.4.0  # For ISBN search API
```

**Platform-Specific Setup:**

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required to scan book barcodes</string>
```

---

## Decision Log

### [November 12, 2025] Decision: mobile_scanner over Custom Camera

**Context:**
Flutter needs barcode scanning on both iOS and Android. Could use platform channels to VisionKit/ML Kit or use existing Flutter package.

**Decision:**
Use `mobile_scanner` package.

**Rationale:**
1. **Cross-platform:** Works on both iOS and Android
2. **Zero custom code:** Package handles all camera/detection logic
3. **Native performance:** Uses Google ML Kit (Android) and AVFoundation (iOS) under the hood
4. **Active maintenance:** Well-maintained package with 1M+ downloads
5. **Feature-rich:** Auto-detection, torch, zoom, multiple formats

**Trade-offs Accepted:**
- Package dependency (external maintenance)
- Platform-specific behaviors may differ slightly
- Limited UI customization (but sufficient for our needs)

**Alternatives Considered:**
- Platform channels to VisionKit/ML Kit: Rejected (too much custom code)
- `qr_code_scanner` package: Rejected (older, less maintained)
- `barcode_scan2`: Rejected (discontinued)

**Outcome:** ✅ Selected for implementation

---

### [November 12, 2025] Decision: ISBN-Specific Formats Only

**Context:**
mobile_scanner supports 15+ barcode formats. Should we scan all or filter?

**Decision:**
Limit to EAN-13, EAN-8, UPC-E (ISBN-specific formats).

**Rationale:**
1. **Reduce false positives:** Product barcodes won't trigger searches
2. **Performance:** Fewer formats = faster detection
3. **User intent:** BooksTrack is for books only

**Implementation:**
```dart
MobileScannerController(
  formats: [
    BarcodeFormat.ean13,
    BarcodeFormat.ean8,
    BarcodeFormat.upcE,
  ],
)
```

**Outcome:** ✅ Configured in scanner initialization

---

### [November 12, 2025] Decision: Auto-Scan with Validation

**Context:**
Should barcode trigger search immediately or require user confirmation?

**Decision:**
Auto-scan on detection, but validate ISBN format first.

**Rationale:**
1. **Speed:** Users want fast scanning (no tap required)
2. **Safety:** Validation prevents false positives
3. **Feedback:** Haptic feedback confirms valid scan
4. **Debounce:** Only process first valid barcode (ignore multiple detections)

**Implementation:**
```dart
bool _hasScanned = false;

onDetect: (capture) {
  if (_hasScanned) return;  // Debounce

  final code = capture.barcodes.first.rawValue;
  if (ISBNValidator.validate(code)) {
    _hasScanned = true;
    HapticFeedback.vibrate();
    _searchByISBN(code);
  }
}
```

**Outcome:** ✅ Implemented with debouncing

---

## Future Enhancements

### High Priority (Next 3 Months)

**1. Multi-Book Batch Scanning**
- Scan 5+ books without leaving scanner
- Add to queue, review after session
- Estimated effort: 2-3 days
- Value: Power users cataloging shelves

**2. Scan History**
- Show last 10 scanned ISBNs
- "Add All to Library" button
- Estimated effort: 1 day
- Value: Recover from accidental dismissal

**3. Analytics Tracking**
- Events: `barcode_scan_success`, `barcode_scan_failure`, `barcode_scan_duration`
- Track format distribution (EAN-13 vs UPC-E)
- Measure adoption rate
- Estimated effort: 0.5 days

### Medium Priority (6 Months)

**4. Image-Based Scanning**
- Scan from photo library (screenshot of book cover)
- Use mobile_scanner's image analysis
- Estimated effort: 2 days
- Value: Scan from saved photos

**5. Manual Correction**
- If scan fails, allow manual digit correction
- Show: `978-0-123-45678-?` (user fills last digit)
- Estimated effort: 1 day

---

## Testing Strategy

### Widget Tests

**Scanner UI Tests:**
- [ ] Scanner screen renders correctly
- [ ] Overlay shows instructions
- [ ] Torch toggle button works
- [ ] Close button dismisses scanner

### Integration Tests

**End-to-End Flow:**
- [ ] Launch scanner → Mock barcode detection → Validate ISBN → Trigger search
- [ ] Invalid barcode → Show error message → Continue scanning
- [ ] Permission denied → Show permission screen → Open settings

**Note:** Real barcode scanning requires physical device (no emulator support)

### Manual Test Scenarios

**Scenario 1: Successful Scan (Happy Path)**
1. Open SearchScreen, tap "Scan ISBN"
2. Camera launches with overlay
3. Point at book barcode (EAN-13)
4. Auto-detects, vibrates, shows book details

**Scenario 2: Permission Denied**
1. Deny camera permission
2. Tap "Scan ISBN"
3. Show permission screen
4. Tap "Open Settings"
5. Enable permission, return to app
6. Scanner works without restart

**Scenario 3: Non-ISBN Barcode**
1. Scan product barcode (shampoo)
2. Validation fails, shows: "Invalid ISBN"
3. Continue scanning (no crash)

**Scenario 4: Low Light**
1. Scan in dark room
2. Tap torch toggle
3. Torch enables, barcode detected

---

## Performance Requirements

| Requirement | Target | Rationale |
|-------------|--------|-----------|
| **Scan Speed** | <1s detection | Near-instant for good UX |
| **Total Time** | <3s scan + API | Faster than manual entry |
| **Memory Usage** | <100MB | Camera preview overhead |
| **Battery Impact** | Minimal | Close scanner after use |

**Flutter-Specific:**
- Camera runs on separate isolate (non-blocking)
- Dispose scanner when screen closes (prevent battery drain)
- Debounce detection (prevent multiple API calls)

---

## Accessibility

**Screen Reader Support:**
- Semantic labels on all buttons
- Announce when barcode detected: "ISBN detected, searching..."

**Visual Accessibility:**
- High contrast overlay (white on dark)
- Large touch targets (48dp minimum)
- Clear instructions ("Point camera at barcode")

**Motor Accessibility:**
- Auto-scan (no precise tap required)
- Torch toggle for low light
- Large close button

---

## Security & Privacy

**Camera Privacy:**
- Permission requested lazily (when user taps "Scan ISBN")
- No background camera access
- Camera preview never saved

**Data Privacy:**
- Only ISBN string transmitted (HTTPS to backend)
- No images sent to server
- No analytics tracking camera usage (only scan events)

---

## Platform-Specific Considerations

### Android
- Uses Google ML Kit for detection
- Requires `CAMERA` permission
- Works on API 21+ (Android 5.0+)
- Material 3 native UI

### iOS
- Uses AVFoundation for detection
- Requires `NSCameraUsageDescription`
- Works on iOS 11.0+
- Follows iOS camera permission patterns

### Behavioral Differences
- Android may have slightly different detection speed (ML Kit vs AVFoundation)
- Torch behavior identical on both platforms
- Permission dialogs platform-specific (system handled)

---

## Launch Checklist

**Pre-Launch:**
- [ ] All P0 acceptance criteria met
- [ ] Widget tests for scanner UI
- [ ] Integration tests with mock barcodes
- [ ] Manual QA on physical iOS and Android devices
- [ ] Performance validated (60 FPS camera preview)
- [ ] Permission handling tested on both platforms
- [ ] ISBN validation prevents false positives
- [ ] Analytics events instrumented

**Post-Launch:**
- [ ] Monitor scan success rates
- [ ] Track adoption (% users trying scanner)
- [ ] Measure average scan duration
- [ ] Collect user feedback on accuracy

---

## Related Features

**Upstream Dependencies:**
- **Search:** Scanner integrates with SearchScreen
- **Book Metadata API:** `/v1/search/isbn` returns canonical data

**Downstream Dependents:**
- **Bookshelf Scanner:** Could reuse barcode logic for bulk scanning
- **Review Queue:** Low-confidence scans could go to review (future)

---

## Appendix

### Barcode Format Reference

**EAN-13 (European Article Number):**
- Format: 13 digits (978/979 prefix for books)
- Example: `978-0-12345-678-9`
- Use: International ISBN standard

**EAN-8:**
- Format: 8 digits (shorter EAN)
- Rare for books

**UPC-E (Universal Product Code):**
- Format: 6-8 digits (compressed UPC-A)
- Use: North American books (older ISBNs)

### Device Compatibility

**Supported Devices:**
- iOS 11.0+ (all devices with camera)
- Android 5.0+ (API 21+)
- **Coverage:** 95%+ of active devices

**Unsupported:**
- Devices without camera (tablets without rear camera)
- Emulators (can test UI, not actual scanning)

---

**PRD Status:** 📝 Draft (Flutter Conversion)
**Implementation Status:** Not Started
**Next Review:** After implementation begins
