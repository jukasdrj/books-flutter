import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:books_tracker/core/data/database/database.dart';

/// A card widget displaying book information in the library
class BookCard extends StatelessWidget {
  final WorkWithLibraryStatus bookData;
  final VoidCallback? onTap;
  final VoidCallback? onStatusChange;

  const BookCard({
    super.key,
    required this.bookData,
    this.onTap,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover
              _buildCoverImage(colorScheme),
              const SizedBox(width: 12),

              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      bookData.work.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Author
                    Text(
                      bookData.displayAuthor,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Reading Progress (if available)
                    if (bookData.readingProgress != null)
                      _buildProgressIndicator(context),

                    // Status Badge and Rating
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatusChip(context),
                        const Spacer(),
                        if (bookData.libraryEntry.personalRating != null)
                          _buildRating(context),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage(ColorScheme colorScheme) {
    final coverUrl = bookData.edition?.coverImageURL;

    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: coverUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: coverUrl,
                fit: BoxFit.cover,
                memCacheWidth: 240,  // 80 * 3 (for 3x displays)
                memCacheHeight: 360, // 120 * 3
                placeholder: (context, url) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => _buildPlaceholder(colorScheme),
              ),
            )
          : _buildPlaceholder(colorScheme),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Icon(
      Icons.book,
      size: 40,
      color: colorScheme.onSurfaceVariant,
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final progress = bookData.readingProgress!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (bookData.libraryEntry.currentPage != null &&
            bookData.edition?.pageCount != null)
          const SizedBox(height: 2),
        if (bookData.libraryEntry.currentPage != null &&
            bookData.edition?.pageCount != null)
          Text(
            'Page ${bookData.libraryEntry.currentPage} of ${bookData.edition!.pageCount}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final statusConfig = _getStatusConfig(bookData.status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusConfig.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusConfig.icon,
            size: 14,
            color: statusConfig.color,
          ),
          const SizedBox(width: 4),
          Text(
            statusConfig.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: statusConfig.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating(BuildContext context) {
    final rating = bookData.libraryEntry.personalRating!;
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  ({Color color, IconData icon, String label}) _getStatusConfig(ReadingStatus status) {
    return switch (status) {
      ReadingStatus.wishlist => (
          color: Colors.purple,
          icon: Icons.bookmark_border,
          label: 'Wishlist',
        ),
      ReadingStatus.toRead => (
          color: Colors.blue,
          icon: Icons.book_outlined,
          label: 'To Read',
        ),
      ReadingStatus.reading => (
          color: Colors.orange,
          icon: Icons.auto_stories,
          label: 'Reading',
        ),
      ReadingStatus.read => (
          color: Colors.green,
          icon: Icons.check_circle_outline,
          label: 'Read',
        ),
    };
  }
}
