import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/database/database.dart';

/// Library Screen - Main screen showing user's book collection
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worksAsync = ref.watch(watchWorksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon!')),
              );
            },
          ),
        ],
      ),
      body: worksAsync.when(
        data: (works) {
          if (works.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildWorksList(context, works);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading library',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Show add book options (scan, search, manual)
          _showAddBookOptions(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Book'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Semantics(
      label: 'Empty library state',
      hint: 'Your book library is currently empty. Use the add book button to start adding books.',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 120,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              semanticLabel: 'Bookshelf icon',
            ),
            const SizedBox(height: 24),
            Text(
              'Your library is empty',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add books by scanning, searching, or manual entry',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _showAddBookOptions(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Book'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorksList(BuildContext context, List<WorkWithAuthors> works) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: works.length,
      itemBuilder: (context, index) {
        final workWithAuthors = works[index];
        final work = workWithAuthors.work;
        final authors = workWithAuthors.authors;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 72,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.book,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(
              work.title,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                if (authors.isNotEmpty)
                  Text(
                    authors.map((a) => a.name).join(', '),
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else if (work.author != null)
                  Text(
                    work.author!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (work.subjectTags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: work.subjectTags.take(3).map((tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
            trailing: _buildReviewStatusBadge(context, work),
            onTap: () {
              // TODO: Navigate to book details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Details for: ${work.title}')),
              );
            },
          ),
        );
      },
    );
  }

  Widget? _buildReviewStatusBadge(BuildContext context, Work work) {
    if (work.reviewStatus == ReviewStatus.needsReview.index) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Review',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
      );
    }
    return null;
  }

  void _showAddBookOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('Scan Barcode'),
                subtitle: const Text('Scan ISBN barcode'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Barcode scanner coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Scan Bookshelf'),
                subtitle: const Text('AI-powered bookshelf scanning'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bookshelf scanner coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search'),
                subtitle: const Text('Search by title or author'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Search coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Manual Entry'),
                subtitle: const Text('Add book details manually'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Manual entry coming soon!')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
