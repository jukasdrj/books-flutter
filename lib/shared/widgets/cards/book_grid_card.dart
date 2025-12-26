import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:books_tracker/core/data/database/database.dart';

/// A compact grid card widget for displaying books in grid view
class BookGridCard extends StatelessWidget {
  final WorkWithLibraryStatus bookData;
  final VoidCallback? onTap;

  const BookGridCard({
    super.key,
    required this.bookData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Book Cover (larger in grid view)
            Expanded(
              flex: 3,
              child: _buildCoverImage(colorScheme),
            ),

            // Book Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      bookData.work.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Author
                    Text(
                      bookData.displayAuthor,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Status indicator and rating
                    Row(
                      children: [
                        _buildStatusDot(colorScheme),
                        const Spacer(),
                        if (bookData.libraryEntry.personalRating != null)
                          _buildCompactRating(theme),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(ColorScheme colorScheme) {
    final coverUrl = bookData.edition?.coverImageURL;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: coverUrl != null
          ? CachedNetworkImage(
              imageUrl: coverUrl,
              fit: BoxFit.cover,
              memCacheWidth: 600,  // Adaptive for grid (larger)
              placeholder: (context, url) => Container(
                color: colorScheme.surfaceContainerHighest,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => _buildPlaceholder(colorScheme),
            )
          : _buildPlaceholder(colorScheme),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Center(
      child: Icon(
        Icons.book,
        size: 48,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildStatusDot(ColorScheme colorScheme) {
    final statusColor = _getStatusColor(bookData.status);

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: statusColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCompactRating(ThemeData theme) {
    final rating = bookData.libraryEntry.personalRating!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: 12,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 2),
        Text(
          rating.toString(),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ReadingStatus status) {
    return switch (status) {
      ReadingStatus.wishlist => Colors.purple,
      ReadingStatus.toRead => Colors.blue,
      ReadingStatus.reading => Colors.orange,
      ReadingStatus.read => Colors.green,
    };
  }
}
