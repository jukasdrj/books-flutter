#!/bin/bash
# Script to create GitHub issues from TODO_REFINED.md
# Run with: bash .github/create_issues.sh

set -e

# First, create all labels
echo "📋 Creating GitHub labels..."

while IFS= read -r line; do
  if [[ $line =~ ^-\ name:\ \"(.*)\" ]]; then
    name="${BASH_REMATCH[1]}"
    read -r line
    color=$(echo "$line" | grep -oP 'color: "\K[^"]+')
    read -r line
    description=$(echo "$line" | grep -oP 'description: "\K[^"]+')

    echo "Creating label: $name"
    gh label create "$name" --color "$color" --description "$description" --force 2>/dev/null || true
  fi
done < .github/labels.yml

echo "✅ Labels created!"
echo ""
echo "📝 Creating GitHub issues from TODO_REFINED.md..."
echo ""

# Phase 1.1 - Critical Performance & Data Fixes

gh issue create \
  --title "[P0] Fix DTOMapper Bug - Author List Order Assumption" \
  --body "## Description
DTOMapper currently assumes author list order matches works, causing data corruption.

## User Story
As a developer, I need correct author-work relationships so that books display accurate author information.

## Acceptance Criteria
- [ ] Add \`authorIds: List<String>\` field to WorkDTO
- [ ] Add \`id: String\` field to AuthorDTO
- [ ] Update dto_mapper.dart:30-34 logic to use authorIds.contains()
- [ ] Backend coordination completed
- [ ] Tests verify correct author mapping
- [ ] Search and Scanner features unblocked

## Technical Details
\`\`\`dart
// Current (broken):
final authors = data.authors.sublist(0, workDTO.authorIds.length);

// Fixed:
final authors = data.authors
    .where((a) => workDTO.authorIds.contains(a.id))
    .toList();
\`\`\`

**Location:** lib/core/services/dto_mapper.dart:30-34

**Blocks:** #2, #3 (Search, Scanner features)

## Effort
4-6 hours

## Implementation Status
✅ COMPLETED - Fixed in commit 83ed131" \
  --label "P0: Critical,type: bug,phase: 1-foundation,component: database,platform: all,effort: M (4-8h),status: in-progress,expert-validated"

gh issue create \
  --title "[P0] Implement Batch Database Queries (N+1 Fix)" \
  --body "## Description
Current implementation calls _getAuthorsForWork() in a loop, creating N+1 query problem.

## User Story
As a user with a large library, I need fast book list loading so that I can browse my collection smoothly.

## Acceptance Criteria
- [ ] Refactor database.dart:223 watchAllWorks()
- [ ] Refactor database.dart:322 watchLibrary()
- [ ] Create _getBatchAuthorsForWorks() method
- [ ] Single query pattern: \`select(authors)..where((t) => t.id.isIn(authorIds))\`
- [ ] Performance test shows 95% query reduction
- [ ] Reusable pattern documented

## Technical Details
\`\`\`dart
// Create batch fetching method
Future<Map<String, List<Author>>> _getBatchAuthorsForWorks(List<String> workIds) async {
  final query = select(authors).join([
    innerJoin(workAuthors, workAuthors.authorId.equalsExp(authors.id)),
  ])..where(workAuthors.workId.isIn(workIds));

  final results = await query.get();

  // Group by workId
  final Map<String, List<Author>> authorsMap = {};
  for (final row in results) {
    final author = row.readTable(authors);
    final workAuthor = row.readTable(workAuthors);
    authorsMap.putIfAbsent(workAuthor.workId, () => []).add(author);
  }

  return authorsMap;
}
\`\`\`

**Location:** lib/core/database/database.dart

**Reusable in:** All list views, Search results, Review Queue

## Effort
3-4 hours

## Implementation Status
✅ COMPLETED - Fixed in commit 1379485" \
  --label "P0: Critical,type: perf,phase: 1-foundation,component: database,platform: all,effort: S (2-4h),status: in-progress,expert-validated"

gh issue create \
  --title "[P0] Implement Keyset Pagination (Replace OFFSET)" \
  --body "## Description
Current OFFSET pagination degrades with 500+ books. Implement cursor-based keyset pagination.

## User Story
As a user with a large library, I need smooth infinite scrolling so that pagination doesn't slow down.

## Acceptance Criteria
- [ ] Replace OFFSET with cursor-based pagination
- [ ] Use composite cursor: \"timestamp|id\"
- [ ] Add indexes on (updatedAt, id)
- [ ] Implement in watchLibrary()
- [ ] Implement in watchAllWorks()
- [ ] Add infinite scroll UI with ScrollController
- [ ] Performance test with 1000+ books
- [ ] Reusable for Search and Review Queue

## Technical Details
\`\`\`dart
Stream<List<WorkWithLibraryStatus>> watchLibrary({
  String? cursor,  // Composite: \"timestamp|id\"
  int limit = 50,
}) {
  final query = select(userLibraryEntries).join([...]);

  if (cursor != null && cursor.contains('|')) {
    final parts = cursor.split('|');
    final lastTimestamp = DateTime.parse(parts[0]);
    final lastId = parts[1];

    query.where(
      userLibraryEntries.updatedAt.isSmallerThanValue(lastTimestamp) |
      (userLibraryEntries.updatedAt.equals(lastTimestamp) &
          userLibraryEntries.id.isSmallerThan(lastId)),
    );
  }

  query
    ..orderBy([
      OrderingTerm.desc(userLibraryEntries.updatedAt),
      OrderingTerm.desc(userLibraryEntries.id),
    ])
    ..limit(limit);
}
\`\`\`

**Database Indexes:**
\`\`\`sql
CREATE INDEX idx_library_updated_id ON user_library_entries (updated_at DESC, id DESC);
\`\`\`

**Location:** lib/core/database/database.dart

## Effort
6-8 hours

## Implementation Status
✅ COMPLETED - Fixed in commit 1379485" \
  --label "P0: Critical,type: perf,phase: 1-foundation,component: database,platform: all,effort: M (4-8h),status: in-progress,expert-validated"

gh issue create \
  --title "[P0] Add Image Caching with CachedNetworkImage" \
  --body "## Description
Replace Image.network with CachedNetworkImage for book covers to improve performance and reduce bandwidth.

## User Story
As a user browsing my library, I need fast image loading so that scrolling is smooth and data usage is minimal.

## Acceptance Criteria
- [ ] Add cached_network_image dependency
- [ ] Replace Image.network in book_card.dart
- [ ] Replace Image.network in book_grid_card.dart
- [ ] Add memCacheWidth/Height optimization
- [ ] Add blurhash placeholders
- [ ] Add error widgets
- [ ] Test with slow network
- [ ] Reusable for all book cover displays

## Technical Details
\`\`\`dart
CachedNetworkImage(
  imageUrl: coverUrl,
  fit: BoxFit.cover,
  memCacheWidth: 240,  // 80 * 3 for Retina
  memCacheHeight: 360, // 120 * 3
  placeholder: (context, url) => BlurhashPlaceholder(hash: book.blurhash),
  errorWidget: (context, url, error) => _buildPlaceholder(colorScheme),
)
\`\`\`

**Dependencies:**
\`\`\`yaml
cached_network_image: ^3.3.0
flutter_blurhash: ^0.8.0
\`\`\`

**Location:**
- lib/shared/widgets/book_card.dart
- lib/shared/widgets/book_grid_card.dart

## Effort
1-2 hours

## Implementation Status
✅ COMPLETED - Fixed in commit 1379485" \
  --label "P0: Critical,type: perf,phase: 1-foundation,component: ui,platform: all,effort: XS (< 2h),status: in-progress,expert-validated"

echo ""
echo "✅ Phase 1.1 issues created!"
echo ""

# Continue with more issues...
echo "To create more issues, extend this script with additional gh issue create commands"
echo ""
echo "📊 Current issues created: 4"
echo "📋 Remaining tasks: Extract from TODO_REFINED.md and create ~50 more issues"
