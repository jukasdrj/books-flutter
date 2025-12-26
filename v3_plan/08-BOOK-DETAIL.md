# 08 - Book Detail Screen

**Priority:** P0 - Core Feature
**Estimated Effort:** 1 day
**Prerequisites:** 01-CRITICAL-FIXES.md, 02-SEARCH-FEATURE.md
**PRD Reference:** Implied by Library and Search features

---

## Overview

The Book Detail Screen displays comprehensive book information and allows users to:
- View book metadata (title, author, cover, description)
- Manage reading status (wishlist, toRead, reading, read)
- Track reading progress (current page)
- Add personal rating (1-5 stars)
- Write notes

This screen is accessed from Library (tap book) and Search results.

---

## Current State

| Component | Status | Notes |
|-----------|--------|-------|
| Database schema | Complete | UserLibraryEntries has all fields |
| BookActionsProvider | Complete | CRUD operations ready |
| Detail screen | Missing | Not implemented |

---

## Target Architecture

```
BookDetailScreen
├── SliverAppBar (collapsing with cover image)
├── Book Info Section
│   ├── Title
│   ├── Author(s)
│   ├── Publisher, year
│   ├── Page count
│   └── Subject tags
├── Status Section
│   ├── Status chips (Wishlist, To Read, Reading, Read)
│   └── Completion date (if Read)
├── Progress Section (if Reading)
│   ├── Current page slider
│   └── Progress percentage
├── Rating Section
│   ├── 5-star rating
│   └── Personal notes
└── Actions
    ├── Edit (future)
    └── Delete
```

---

## Implementation Plan

### Step 1: Create Book Detail Screen

**File:** `lib/features/library/screens/book_detail_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/data/database/database.dart';
import '../providers/book_actions_provider.dart';

/// Displays detailed book information with editing capabilities.
class BookDetailScreen extends ConsumerStatefulWidget {
  /// The work to display.
  final WorkWithLibraryStatus work;

  const BookDetailScreen({
    super.key,
    required this.work,
  });

  @override
  ConsumerState<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  late ReadingStatus _status;
  late int _currentPage;
  late int _rating;
  late TextEditingController _notesController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _status = widget.work.libraryEntry?.status ?? ReadingStatus.toRead;
    _currentPage = widget.work.libraryEntry?.currentPage ?? 0;
    _rating = widget.work.libraryEntry?.personalRating ?? 0;
    _notesController = TextEditingController(
      text: widget.work.libraryEntry?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final work = widget.work.work;
    final edition = widget.work.edition;
    final authors = widget.work.authors;
    final coverUrl = edition?.coverImageUrl;
    final pageCount = edition?.pageCount ?? 0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsing AppBar with cover
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: coverUrl != null
                  ? CachedNetworkImage(
                      imageUrl: coverUrl,
                      fit: BoxFit.cover,
                      memCacheWidth: 600,
                    )
                  : Container(
                      color: theme.colorScheme.primaryContainer,
                      child: const Icon(Icons.book, size: 100),
                    ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: _confirmDelete,
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Author
                  Text(
                    work.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authors.map((a) => a.name).join(', '),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Metadata row
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      if (edition?.publishedYear != null)
                        _MetadataChip(
                          icon: Icons.calendar_today,
                          label: edition!.publishedYear.toString(),
                        ),
                      if (pageCount > 0)
                        _MetadataChip(
                          icon: Icons.menu_book,
                          label: '$pageCount pages',
                        ),
                      if (edition?.publisher != null)
                        _MetadataChip(
                          icon: Icons.business,
                          label: edition!.publisher!,
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Subject tags
                  if (work.subjectTags.isNotEmpty) ...[
                    Text('Genres', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: work.subjectTags.map((tag) {
                        return Chip(label: Text(tag));
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Reading Status
                  Text('Reading Status', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  _StatusChips(
                    selected: _status,
                    onChanged: (status) {
                      setState(() {
                        _status = status;
                        _hasChanges = true;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Progress (if reading)
                  if (_status == ReadingStatus.reading && pageCount > 0) ...[
                    Text('Reading Progress', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    _ProgressSlider(
                      currentPage: _currentPage,
                      totalPages: pageCount,
                      onChanged: (page) {
                        setState(() {
                          _currentPage = page;
                          _hasChanges = true;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Rating
                  Text('Your Rating', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  _StarRating(
                    rating: _rating,
                    onChanged: (rating) {
                      setState(() {
                        _rating = rating;
                        _hasChanges = true;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Notes
                  Text('Personal Notes', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Add your thoughts...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      setState(() => _hasChanges = true);
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _hasChanges
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: _saveChanges,
                  child: const Text('Save Changes'),
                ),
              ),
            )
          : null,
    );
  }

  Future<void> _saveChanges() async {
    final actions = ref.read(bookActionsProvider.notifier);
    final entryId = widget.work.libraryEntry?.id;

    if (entryId == null) return;

    try {
      await actions.updateReadingStatus(entryId, _status);
      await actions.updateCurrentPage(entryId, _currentPage);
      await actions.updateRating(entryId, _rating);
      await actions.updateNotes(entryId, _notesController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved')),
        );
        setState(() => _hasChanges = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Library?'),
        content: Text(
          'Remove "${widget.work.work.title}" from your library?',
        ),
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
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final entryId = widget.work.libraryEntry?.id;
      if (entryId != null) {
        await ref.read(bookActionsProvider.notifier).deleteFromLibrary(entryId);
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetadataChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _StatusChips extends StatelessWidget {
  final ReadingStatus selected;
  final ValueChanged<ReadingStatus> onChanged;

  const _StatusChips({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ReadingStatus.values.map((status) {
        return ChoiceChip(
          label: Text(_formatStatus(status)),
          selected: selected == status,
          onSelected: (_) => onChanged(status),
        );
      }).toList(),
    );
  }

  String _formatStatus(ReadingStatus status) {
    return switch (status) {
      ReadingStatus.wishlist => 'Wishlist',
      ReadingStatus.toRead => 'To Read',
      ReadingStatus.reading => 'Reading',
      ReadingStatus.read => 'Read',
    };
  }
}

class _ProgressSlider extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onChanged;

  const _ProgressSlider({
    required this.currentPage,
    required this.totalPages,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalPages > 0
        ? (currentPage / totalPages * 100).round()
        : 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Page $currentPage of $totalPages'),
            Text('$percentage%'),
          ],
        ),
        Slider(
          value: currentPage.toDouble(),
          min: 0,
          max: totalPages.toDouble(),
          divisions: totalPages > 0 ? totalPages : null,
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const _StarRating({
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        return IconButton(
          icon: Icon(
            starNumber <= rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () => onChanged(starNumber),
        );
      }),
    );
  }
}
```

---

### Step 2: Update Book Actions Provider

Ensure `lib/features/library/providers/book_actions_provider.dart` has all methods:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/data/database/database.dart';

part 'book_actions_provider.g.dart';

@riverpod
class BookActions extends _$BookActions {
  @override
  FutureOr<void> build() {}

  /// Updates the reading status of a library entry.
  Future<void> updateReadingStatus(String entryId, ReadingStatus status) async {
    final database = ref.read(databaseProvider);
    await database.updateReadingStatus(entryId, status);
  }

  /// Updates the current page for a library entry.
  Future<void> updateCurrentPage(String entryId, int page) async {
    final database = ref.read(databaseProvider);
    await database.updateCurrentPage(entryId, page);
  }

  /// Updates the personal rating (1-5 stars).
  Future<void> updateRating(String entryId, int rating) async {
    final database = ref.read(databaseProvider);
    await database.updateRating(entryId, rating);
  }

  /// Updates personal notes.
  Future<void> updateNotes(String entryId, String notes) async {
    final database = ref.read(databaseProvider);
    await database.updateNotes(entryId, notes);
  }

  /// Deletes a book from the library.
  Future<void> deleteFromLibrary(String entryId) async {
    final database = ref.read(databaseProvider);
    await database.deleteLibraryEntry(entryId);
  }

  /// Adds a book to the library with initial status.
  Future<void> addToLibrary({
    required String workId,
    String? editionId,
    ReadingStatus status = ReadingStatus.toRead,
  }) async {
    final database = ref.read(databaseProvider);
    await database.upsertLibraryEntry(
      workId: workId,
      editionId: editionId,
      status: status,
    );
  }
}
```

---

### Step 3: Add Database Methods

Add to `lib/core/data/database/database.dart`:

```dart
/// Updates reading status for a library entry.
Future<void> updateReadingStatus(String entryId, ReadingStatus status) async {
  final now = DateTime.now();

  await (update(userLibraryEntries)..where((e) => e.id.equals(entryId))).write(
    UserLibraryEntriesCompanion(
      status: Value(status),
      completionDate: status == ReadingStatus.read
          ? Value(now)
          : const Value.absent(),
      updatedAt: Value(now),
    ),
  );
}

/// Updates current page for a library entry.
Future<void> updateCurrentPage(String entryId, int page) async {
  await (update(userLibraryEntries)..where((e) => e.id.equals(entryId))).write(
    UserLibraryEntriesCompanion(
      currentPage: Value(page),
      updatedAt: Value(DateTime.now()),
    ),
  );
}

/// Updates personal rating (1-5).
Future<void> updateRating(String entryId, int rating) async {
  await (update(userLibraryEntries)..where((e) => e.id.equals(entryId))).write(
    UserLibraryEntriesCompanion(
      personalRating: Value(rating),
      updatedAt: Value(DateTime.now()),
    ),
  );
}

/// Updates personal notes.
Future<void> updateNotes(String entryId, String notes) async {
  await (update(userLibraryEntries)..where((e) => e.id.equals(entryId))).write(
    UserLibraryEntriesCompanion(
      notes: Value(notes),
      updatedAt: Value(DateTime.now()),
    ),
  );
}

/// Deletes a library entry.
Future<void> deleteLibraryEntry(String entryId) async {
  await (delete(userLibraryEntries)..where((e) => e.id.equals(entryId))).go();
}
```

---

### Step 4: Navigate from Library Screen

Update `lib/features/library/screens/library_screen.dart`:

```dart
import 'book_detail_screen.dart';

// In BookCard or BookGridCard onTap:
onTap: () {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => BookDetailScreen(work: work),
    ),
  );
},
```

---

## Testing Strategy

### Unit Tests

- [ ] updateReadingStatus sets status and completionDate
- [ ] updateCurrentPage updates page number
- [ ] updateRating stores 1-5 value
- [ ] deleteLibraryEntry removes entry

### Widget Tests

- [ ] BookDetailScreen renders book info
- [ ] Status chips update selected state
- [ ] Progress slider updates on drag
- [ ] Star rating responds to taps
- [ ] Save button appears on changes

### Integration Tests

- [ ] Navigate from library → detail → update → back → see changes
- [ ] Delete book → removed from library

---

## Accessibility Considerations

- [ ] SliverAppBar has semantic label for cover image
- [ ] Status chips have proper semantics
- [ ] Star rating uses semantic buttons
- [ ] Notes field has accessible hint
- [ ] Delete confirmation is keyboard accessible

---

## Files to Create

| File | Type | Description |
|------|------|-------------|
| `lib/features/library/screens/book_detail_screen.dart` | Screen | Book detail UI |

---

## Files to Modify

| File | Change |
|------|--------|
| `lib/features/library/providers/book_actions_provider.dart` | Add updateNotes method |
| `lib/core/data/database/database.dart` | Add CRUD methods |
| `lib/features/library/screens/library_screen.dart` | Add navigation to detail |
| `lib/shared/widgets/cards/book_card.dart` | Add onTap callback |

---

## Next Steps

After implementing Book Detail:
1. All core features are complete
2. Focus on testing and polish
3. Run `flutter analyze` and fix any linting issues
4. Add unit and widget tests

---

**Document Status:** Ready for Implementation
**Last Updated:** December 26, 2025
