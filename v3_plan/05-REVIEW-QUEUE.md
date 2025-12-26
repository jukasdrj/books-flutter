# 05 - Review Queue Implementation

**Priority:** P1 - Data Quality
**Estimated Effort:** 1-2 days
**Prerequisites:** 04-BOOKSHELF-SCANNER.md
**PRD Reference:** `product/Review-Queue-PRD-Flutter.md`

---

## Overview

The Review Queue provides a human-in-the-loop workflow for correcting low-confidence AI detections (<60% confidence). Users review cropped spine images alongside editable title/author fields to ensure library accuracy.

---

## Current State

| Component | Status | Notes |
|-----------|--------|-------|
| DetectedItems table | Complete | Has reviewStatus field |
| Works table | Complete | Has reviewStatus, boundingBox fields |
| Review Queue feature | Stub only | Empty folder with barrel export |

---

## Target Architecture

```
Library Screen
└── AppBar with ReviewQueueBadge
    └── Badge showing count of needsReview items

ReviewQueueScreen (navigated from badge)
├── AppBar with title and count
├── ListView of queued books
│   └── ReviewQueueCard (per book)
│       ├── Thumbnail/placeholder
│       ├── Title, author
│       ├── Confidence chip
│       └── Tap → CorrectionScreen
└── Empty state when queue cleared

CorrectionScreen
├── Cropped spine image (if available)
├── TextFormField: Title (editable)
├── TextFormField: Author (editable)
├── Confidence indicator
└── Actions: Delete, Mark Verified, Save Changes
```

---

## Implementation Plan

### Step 1: Create Review Queue Provider

**File:** `lib/features/review_queue/providers/review_queue_provider.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/data/database/database.dart';

part 'review_queue_provider.g.dart';

/// Provides the count of books needing review.
@riverpod
Stream<int> reviewQueueCount(ReviewQueueCountRef ref) {
  final database = ref.watch(databaseProvider);
  return database.watchReviewQueueCount();
}

/// Provides the list of books needing review.
@riverpod
Stream<List<Work>> reviewQueue(ReviewQueueRef ref) {
  final database = ref.watch(databaseProvider);
  return database.watchReviewQueue();
}

/// Actions for reviewing books.
@riverpod
class ReviewActions extends _$ReviewActions {
  @override
  FutureOr<void> build() {}

  /// Marks a book as verified (AI was correct).
  Future<void> markVerified(String workId) async {
    final database = ref.read(databaseProvider);
    await database.updateReviewStatus(workId, ReviewStatus.verified);
  }

  /// Saves user corrections to title/author.
  Future<void> saveCorrections({
    required String workId,
    required String title,
    required String author,
  }) async {
    final database = ref.read(databaseProvider);
    await database.updateWorkDetails(
      workId: workId,
      title: title,
      author: author,
      reviewStatus: ReviewStatus.userEdited,
    );
  }

  /// Deletes a book from the library.
  Future<void> deleteBook(String workId) async {
    final database = ref.read(databaseProvider);
    await database.deleteWork(workId);
  }
}
```

---

### Step 2: Add Database Queries

Add to `lib/core/data/database/database.dart`:

```dart
/// Watches the count of books needing review.
Stream<int> watchReviewQueueCount() {
  final query = selectOnly(works)
    ..addColumns([works.id.count()])
    ..where(works.reviewStatus.equals(ReviewStatus.needsReview.index));

  return query
      .map((row) => row.read(works.id.count()) ?? 0)
      .watchSingle();
}

/// Watches all books needing review.
Stream<List<Work>> watchReviewQueue() {
  final query = select(works)
    ..where((w) => w.reviewStatus.equals(ReviewStatus.needsReview.index))
    ..orderBy([
      (w) => OrderingTerm(expression: w.aiConfidence, mode: OrderingMode.asc),
    ]);

  return query.watch();
}

/// Updates the review status of a work.
Future<void> updateReviewStatus(String workId, ReviewStatus status) async {
  await (update(works)..where((w) => w.id.equals(workId))).write(
    WorksCompanion(reviewStatus: Value(status)),
  );
}

/// Updates work details after user correction.
Future<void> updateWorkDetails({
  required String workId,
  required String title,
  required String author,
  required ReviewStatus reviewStatus,
}) async {
  await (update(works)..where((w) => w.id.equals(workId))).write(
    WorksCompanion(
      title: Value(title),
      author: Value(author),
      reviewStatus: Value(reviewStatus),
    ),
  );
}
```

---

### Step 3: Create Review Queue Badge Widget

**File:** `lib/features/review_queue/widgets/review_queue_badge.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/review_queue_provider.dart';
import '../screens/review_queue_screen.dart';

/// Badge showing count of books needing review.
///
/// Displays in the app bar when there are items to review.
class ReviewQueueBadge extends ConsumerWidget {
  const ReviewQueueBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(reviewQueueCountProvider);

    return countAsync.when(
      data: (count) {
        if (count == 0) return const SizedBox.shrink();

        return Badge(
          label: Text(count.toString()),
          child: IconButton(
            icon: const Icon(Icons.rate_review_outlined),
            tooltip: '$count books need review',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const ReviewQueueScreen(),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
```

---

### Step 4: Create Review Queue Screen

**File:** `lib/features/review_queue/screens/review_queue_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/database/database.dart';
import '../providers/review_queue_provider.dart';
import 'correction_screen.dart';

/// Screen listing all books needing human review.
class ReviewQueueScreen extends ConsumerWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(reviewQueueProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Queue'),
      ),
      body: queueAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return _ReviewQueueCard(
                book: book,
                onTap: () => _openCorrection(context, book),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'All books verified!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'No books need review',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _openCorrection(BuildContext context, Work book) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CorrectionScreen(work: book),
      ),
    );
  }
}

class _ReviewQueueCard extends StatelessWidget {
  final Work book;
  final VoidCallback onTap;

  const _ReviewQueueCard({
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final confidence = book.aiConfidence ?? 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          child: Icon(Icons.book),
        ),
        title: Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(book.author ?? 'Unknown author'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text('${(confidence * 100).toInt()}%'),
              backgroundColor: Colors.orange[100],
              labelStyle: TextStyle(color: Colors.orange[800]),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
```

---

### Step 5: Create Correction Screen

**File:** `lib/features/review_queue/screens/correction_screen.dart`

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/database/database.dart';
import '../providers/review_queue_provider.dart';

/// Screen for correcting or verifying a single book.
class CorrectionScreen extends ConsumerStatefulWidget {
  final Work work;

  const CorrectionScreen({
    super.key,
    required this.work,
  });

  @override
  ConsumerState<CorrectionScreen> createState() => _CorrectionScreenState();
}

class _CorrectionScreenState extends ConsumerState<CorrectionScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.work.title);
    _authorController = TextEditingController(text: widget.work.author ?? '');

    _titleController.addListener(_checkChanges);
    _authorController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final hasChanges = _titleController.text != widget.work.title ||
        _authorController.text != (widget.work.author ?? '');
    if (hasChanges != _hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final confidence = widget.work.aiConfidence ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Book'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Spine image (if available)
            if (widget.work.originalImagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(widget.work.originalImagePath!),
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                ),
              )
            else
              _buildImagePlaceholder(),

            const SizedBox(height: 24),

            // Confidence indicator
            Center(
              child: Chip(
                avatar: const Icon(Icons.auto_awesome, size: 18),
                label: Text('AI Confidence: ${(confidence * 100).toInt()}%'),
                backgroundColor: Colors.orange[100],
              ),
            ),

            const SizedBox(height: 24),

            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 16),

            // Author field
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Author',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_hasChanges)
                FilledButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                )
              else
                FilledButton(
                  onPressed: _markVerified,
                  child: const Text('Mark as Verified'),
                ),

              const SizedBox(height: 8),

              OutlinedButton(
                onPressed: _deleteBook,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Delete Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('No image available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    await ref.read(reviewActionsProvider.notifier).saveCorrections(
      workId: widget.work.id,
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _markVerified() async {
    await ref.read(reviewActionsProvider.notifier).markVerified(widget.work.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book verified')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteBook() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book?'),
        content: const Text('This book will be removed from your library.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(reviewActionsProvider.notifier).deleteBook(widget.work.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book deleted')),
        );
        Navigator.of(context).pop();
      }
    }
  }
}
```

---

### Step 6: Integrate Badge into Library Screen

Update `lib/features/library/screens/library_screen.dart`:

```dart
import '../../review_queue/widgets/review_queue_badge.dart';

// In AppBar actions:
AppBar(
  title: const Text('Library'),
  actions: const [
    ReviewQueueBadge(), // Add this
    // ... other actions
  ],
),
```

---

## Testing Strategy

### Unit Tests

- [ ] reviewQueueCount updates when status changes
- [ ] markVerified updates reviewStatus to verified
- [ ] saveCorrections updates title, author, and status
- [ ] deleteBook removes work from database

### Widget Tests

- [ ] ReviewQueueBadge shows/hides based on count
- [ ] ReviewQueueScreen displays queued books
- [ ] CorrectionScreen pre-fills with work data
- [ ] Save/Verify/Delete buttons work correctly

### Integration Tests

- [ ] Full flow: Scan → Low confidence → Review → Verify
- [ ] Correction flow: Edit title → Save → Status updated

---

## Files to Create

| File | Type | Description |
|------|------|-------------|
| `lib/features/review_queue/providers/review_queue_provider.dart` | Provider | Queue state |
| `lib/features/review_queue/widgets/review_queue_badge.dart` | Widget | AppBar badge |
| `lib/features/review_queue/screens/review_queue_screen.dart` | Screen | Queue list |
| `lib/features/review_queue/screens/correction_screen.dart` | Screen | Edit book |

---

## Next Steps

After implementing Review Queue:
1. **06-INSIGHTS.md** - Reading statistics and diversity analytics
2. Test with various confidence levels and edge cases

---

**Document Status:** Ready for Implementation
**Last Updated:** December 26, 2025
