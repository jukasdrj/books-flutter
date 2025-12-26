import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/data/models/dtos/work_dto.dart';
import '../../../core/data/models/dtos/edition_dto.dart';
import '../../../core/data/models/dtos/author_dto.dart';

/// Card displaying a single search result for a book
class BookSearchResultCard extends StatelessWidget {
  final WorkDTO work;
  final EditionDTO? edition;
  final List<AuthorDTO> authors;
  final VoidCallback? onTap;
  final VoidCallback? onAddToLibrary;

  const BookSearchResultCard({
    super.key,
    required this.work,
    this.edition,
    required this.authors,
    this.onTap,
    this.onAddToLibrary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Book Cover
              _buildCover(colorScheme),
              const SizedBox(width: 12),

              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      work.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (authors.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      // Authors
                      Text(
                        _formatAuthors(authors),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    if (edition != null) ...[
                      const SizedBox(height: 4),
                      // Edition Details
                      Row(
                        children: [
                          if (edition!.publishedYear != null)
                            Text(
                              '${edition!.publishedYear}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          if (edition!.publishedYear != null && edition!.publisher != null)
                            Text(' • ', style: theme.textTheme.bodySmall),
                          if (edition!.publisher != null)
                            Expanded(
                              child: Text(
                                edition!.publisher!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],

                    if (edition?.isbn != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'ISBN: ${edition!.isbn}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Add to Library Button
              if (onAddToLibrary != null) ...[
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: onAddToLibrary,
                  icon: const Icon(Icons.add),
                  iconSize: 20,
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                  ),
                  tooltip: 'Add to Library',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover(ColorScheme colorScheme) {
    final coverUrl = edition?.coverImageURL;

    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: colorScheme.surfaceContainerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: coverUrl != null
          ? CachedNetworkImage(
              imageUrl: coverUrl,
              fit: BoxFit.cover,
              memCacheWidth: 120, // 60 * 2 for 2x displays
              memCacheHeight: 160, // 80 * 2
              placeholder: (context, url) => Container(
                color: colorScheme.surfaceContainerHighest,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => _buildPlaceholder(colorScheme),
            )
          : _buildPlaceholder(colorScheme),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.book_outlined,
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }

  String _formatAuthors(List<AuthorDTO> authors) {
    if (authors.isEmpty) return 'Unknown Author';
    if (authors.length == 1) return authors.first.name;
    if (authors.length == 2) {
      return '${authors.first.name} & ${authors.last.name}';
    }
    return '${authors.first.name} & ${authors.length - 1} others';
  }
}