# 06 - Insights & Analytics Implementation

**Priority:** P1 - Core Feature
**Estimated Effort:** 2-3 days
**Prerequisites:** 01-CRITICAL-FIXES.md
**PRD Reference:** `product/Diversity-Insights-PRD.md`, `product/Reading-Statistics-PRD.md`

---

## Overview

The Insights tab provides reading analytics and diversity insights:
- **Reading Statistics** - Books read, status distribution, progress tracking
- **Diversity Insights** - Cultural regions, gender representation, languages

---

## Current State

| Component | Status | Notes |
|-----------|--------|-------|
| InsightsScreen | Placeholder | Shows "Coming soon" message |
| Database fields | Complete | Author gender, culturalRegion available |
| ReadingStatistics helper | Exists | Basic computation in database.dart |
| Charts package | In pubspec | `fl_chart` available |

---

## Target Architecture

```
InsightsScreen
├── ScrollView
│   ├── TimePeriodPicker (All Time, This Year, Last 30 Days)
│   ├── HeroStatsCard (4 key metrics)
│   ├── ReadingStatsSection
│   │   ├── Status Distribution (pie chart)
│   │   └── Currently Reading list
│   ├── DiversitySection
│   │   ├── Cultural Regions (bar chart)
│   │   ├── Gender Representation (donut chart)
│   │   └── Language Tag Cloud
│   └── RecentlyCompletedSection
└── Empty state when no books
```

---

## Implementation Plan

### Step 1: Create Statistics Models

**File:** `lib/features/insights/models/reading_stats.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_stats.freezed.dart';

/// Time period for filtering statistics.
enum TimePeriod {
  allTime('All Time'),
  thisYear('This Year'),
  last30Days('Last 30 Days');

  final String label;
  const TimePeriod(this.label);
}

/// Reading statistics for a given time period.
@freezed
class ReadingStats with _$ReadingStats {
  const factory ReadingStats({
    required int booksReadThisYear,
    required int totalBooks,
    required int currentlyReading,
    required int averagePages,
    required Map<String, int> statusDistribution,
  }) = _ReadingStats;

  const ReadingStats._();

  /// Total books in the library.
  int get librarySize => statusDistribution.values.fold(0, (a, b) => a + b);
}

/// Diversity statistics for the library.
@freezed
class DiversityStats with _$DiversityStats {
  const factory DiversityStats({
    required double diversityScore,
    required Map<String, int> regionDistribution,
    required Map<String, int> genderDistribution,
    required Map<String, int> languageDistribution,
    required int totalAuthors,
    required int regionsRepresented,
    required double marginalizedPercentage,
  }) = _DiversityStats;

  const DiversityStats._();

  /// Calculates diversity score (0-10 scale).
  ///
  /// Components:
  /// - Region score: (regionsRepresented / 11) × 3.0
  /// - Gender score: genderDiversity × 3.0
  /// - Language score: min(languages / 5, 1.0) × 2.0
  /// - Marginalized score: (marginalizedPercentage / 100) × 2.0
  static double calculateScore({
    required int regionsRepresented,
    required double genderDiversity,
    required int languages,
    required double marginalizedPercentage,
  }) {
    final regionScore = (regionsRepresented / 11) * 3.0;
    final genderScore = genderDiversity * 3.0;
    final languageScore = (languages / 5).clamp(0.0, 1.0) * 2.0;
    final marginalizedScore = (marginalizedPercentage / 100) * 2.0;

    return regionScore + genderScore + languageScore + marginalizedScore;
  }
}
```

---

### Step 2: Create Statistics Providers

**File:** `lib/features/insights/providers/stats_providers.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/data/database/database.dart';
import '../models/reading_stats.dart';

part 'stats_providers.g.dart';

/// Current time period for statistics.
@riverpod
class TimePeriodNotifier extends _$TimePeriodNotifier {
  @override
  TimePeriod build() => TimePeriod.thisYear;

  void setPeriod(TimePeriod period) => state = period;
}

/// Reading statistics for the selected time period.
@riverpod
Future<ReadingStats> readingStats(ReadingStatsRef ref) async {
  final database = ref.watch(databaseProvider);
  final period = ref.watch(timePeriodNotifierProvider);

  return database.getReadingStats(period);
}

/// Diversity statistics for the library.
@riverpod
Future<DiversityStats> diversityStats(DiversityStatsRef ref) async {
  final database = ref.watch(databaseProvider);

  return database.getDiversityStats();
}

/// List of currently reading books.
@riverpod
Stream<List<WorkWithLibraryStatus>> currentlyReading(
  CurrentlyReadingRef ref,
) {
  final database = ref.watch(databaseProvider);
  return database.watchCurrentlyReading();
}

/// Recently completed books (last 10).
@riverpod
Stream<List<WorkWithLibraryStatus>> recentlyCompleted(
  RecentlyCompletedRef ref,
) {
  final database = ref.watch(databaseProvider);
  return database.watchRecentlyCompleted(limit: 10);
}
```

---

### Step 3: Add Database Queries

Add to `lib/core/data/database/database.dart`:

```dart
/// Gets reading statistics for a time period.
Future<ReadingStats> getReadingStats(TimePeriod period) async {
  final now = DateTime.now();
  DateTime? startDate;

  switch (period) {
    case TimePeriod.allTime:
      startDate = null;
    case TimePeriod.thisYear:
      startDate = DateTime(now.year, 1, 1);
    case TimePeriod.last30Days:
      startDate = now.subtract(const Duration(days: 30));
  }

  // Books read in period
  var readQuery = select(userLibraryEntries)
    ..where((e) => e.status.equals(ReadingStatus.read.index));

  if (startDate != null) {
    readQuery = readQuery
      ..where((e) => e.completionDate.isBiggerOrEqualValue(startDate!));
  }

  final booksRead = await readQuery.get();

  // Status distribution
  final allEntries = await select(userLibraryEntries).get();
  final statusDistribution = <String, int>{};
  for (final entry in allEntries) {
    final status = ReadingStatus.values[entry.status].name;
    statusDistribution[status] = (statusDistribution[status] ?? 0) + 1;
  }

  // Currently reading count
  final currentlyReading = await (select(userLibraryEntries)
        ..where((e) => e.status.equals(ReadingStatus.reading.index)))
      .get();

  // Average page count
  final editionsWithPages = await (select(editions)
        ..where((e) => e.pageCount.isNotNull()))
      .get();
  final avgPages = editionsWithPages.isNotEmpty
      ? editionsWithPages.map((e) => e.pageCount!).reduce((a, b) => a + b) ~/
          editionsWithPages.length
      : 0;

  return ReadingStats(
    booksReadThisYear: booksRead.length,
    totalBooks: allEntries.length,
    currentlyReading: currentlyReading.length,
    averagePages: avgPages,
    statusDistribution: statusDistribution,
  );
}

/// Gets diversity statistics.
Future<DiversityStats> getDiversityStats() async {
  final allAuthors = await select(authors).get();

  // Region distribution
  final regionDist = <String, int>{};
  for (final author in allAuthors) {
    if (author.culturalRegion != null) {
      final region = CulturalRegion.values[author.culturalRegion!].name;
      regionDist[region] = (regionDist[region] ?? 0) + 1;
    }
  }

  // Gender distribution
  final genderDist = <String, int>{};
  for (final author in allAuthors) {
    if (author.gender != null) {
      final gender = AuthorGender.values[author.gender!].name;
      genderDist[gender] = (genderDist[gender] ?? 0) + 1;
    }
  }

  // Language distribution (from works)
  final allWorks = await select(works).get();
  final langDist = <String, int>{};
  for (final work in allWorks) {
    final lang = work.originalLanguage ?? 'Unknown';
    langDist[lang] = (langDist[lang] ?? 0) + 1;
  }

  // Calculate diversity score
  final marginalizedCount = allAuthors.where((a) =>
      a.culturalRegion != null &&
      [
        CulturalRegion.africa.index,
        CulturalRegion.middleEast.index,
        CulturalRegion.southAsia.index,
      ].contains(a.culturalRegion)).length;

  final marginalizedPct = allAuthors.isNotEmpty
      ? (marginalizedCount / allAuthors.length) * 100
      : 0.0;

  final genderDiversity = _calculateShannonEntropy(genderDist);

  final score = DiversityStats.calculateScore(
    regionsRepresented: regionDist.length,
    genderDiversity: genderDiversity,
    languages: langDist.length,
    marginalizedPercentage: marginalizedPct,
  );

  return DiversityStats(
    diversityScore: score,
    regionDistribution: regionDist,
    genderDistribution: genderDist,
    languageDistribution: langDist,
    totalAuthors: allAuthors.length,
    regionsRepresented: regionDist.length,
    marginalizedPercentage: marginalizedPct,
  );
}

double _calculateShannonEntropy(Map<String, int> distribution) {
  if (distribution.isEmpty) return 0;

  final total = distribution.values.reduce((a, b) => a + b);
  if (total == 0) return 0;

  var entropy = 0.0;
  for (final count in distribution.values) {
    if (count > 0) {
      final p = count / total;
      entropy -= p * (log(p) / log(distribution.length));
    }
  }

  return entropy.clamp(0.0, 1.0);
}

/// Watches currently reading books.
Stream<List<WorkWithLibraryStatus>> watchCurrentlyReading() {
  // Implementation using existing watchLibrary with filter
  return watchLibrary(filterStatus: ReadingStatus.reading);
}

/// Watches recently completed books.
Stream<List<WorkWithLibraryStatus>> watchRecentlyCompleted({int limit = 10}) {
  // Implementation: filter by read status, order by completionDate desc
}
```

---

### Step 4: Create Insights Screen

**File:** `lib/features/insights/screens/insights_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_providers.dart';
import '../widgets/hero_stats_card.dart';
import '../widgets/status_distribution_chart.dart';
import '../widgets/cultural_regions_chart.dart';
import '../widgets/gender_donut_chart.dart';
import '../widgets/language_tag_cloud.dart';
import '../widgets/currently_reading_list.dart';

/// Main insights and analytics screen.
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(timePeriodNotifierProvider);
    final readingStatsAsync = ref.watch(readingStatsProvider);
    final diversityStatsAsync = ref.watch(diversityStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(readingStatsProvider);
          ref.invalidate(diversityStatsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Time Period Picker
              _TimePeriodPicker(
                selected: period,
                onChanged: (p) {
                  ref.read(timePeriodNotifierProvider.notifier).setPeriod(p);
                },
              ),

              const SizedBox(height: 16),

              // Reading Stats Section
              readingStatsAsync.when(
                data: (stats) => Column(
                  children: [
                    HeroStatsCard(stats: stats),
                    const SizedBox(height: 16),
                    StatusDistributionChart(
                      distribution: stats.statusDistribution,
                    ),
                  ],
                ),
                loading: () => const _LoadingCard(),
                error: (e, _) => _ErrorCard(error: e.toString()),
              ),

              const SizedBox(height: 24),

              // Diversity Section
              Text(
                'Diversity Insights',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              diversityStatsAsync.when(
                data: (stats) => Column(
                  children: [
                    _DiversityScoreCard(score: stats.diversityScore),
                    const SizedBox(height: 16),
                    CulturalRegionsChart(
                      distribution: stats.regionDistribution,
                    ),
                    const SizedBox(height: 16),
                    GenderDonutChart(
                      distribution: stats.genderDistribution,
                      totalAuthors: stats.totalAuthors,
                    ),
                    const SizedBox(height: 16),
                    LanguageTagCloud(
                      distribution: stats.languageDistribution,
                    ),
                  ],
                ),
                loading: () => const _LoadingCard(),
                error: (e, _) => _ErrorCard(error: e.toString()),
              ),

              const SizedBox(height: 24),

              // Currently Reading
              Text(
                'Currently Reading',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const CurrentlyReadingList(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimePeriodPicker extends StatelessWidget {
  final TimePeriod selected;
  final ValueChanged<TimePeriod> onChanged;

  const _TimePeriodPicker({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TimePeriod>(
      segments: TimePeriod.values
          .map((p) => ButtonSegment(value: p, label: Text(p.label)))
          .toList(),
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _DiversityScoreCard extends StatelessWidget {
  final double score;

  const _DiversityScoreCard({required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              score.toStringAsFixed(1),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '/ 10',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diversity Score',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Based on cultural regions, gender, and languages',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;

  const _ErrorCard({required this.error});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error: $error',
          style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
        ),
      ),
    );
  }
}
```

---

### Step 5: Create Chart Widgets

**File:** `lib/features/insights/widgets/hero_stats_card.dart`

```dart
import 'package:flutter/material.dart';
import '../models/reading_stats.dart';

/// Hero card showing 4 key reading metrics.
class HeroStatsCard extends StatelessWidget {
  final ReadingStats stats;

  const HeroStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                icon: Icons.check_circle,
                value: stats.booksReadThisYear.toString(),
                label: 'Read This Year',
              ),
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.library_books,
                value: stats.totalBooks.toString(),
                label: 'Total Books',
              ),
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.menu_book,
                value: stats.currentlyReading.toString(),
                label: 'Reading',
              ),
            ),
            Expanded(
              child: _StatItem(
                icon: Icons.article,
                value: stats.averagePages.toString(),
                label: 'Avg Pages',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
```

**File:** `lib/features/insights/widgets/status_distribution_chart.dart`

```dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Pie chart showing book status distribution.
class StatusDistributionChart extends StatelessWidget {
  final Map<String, int> distribution;

  const StatusDistributionChart({
    super.key,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    if (distribution.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = {
      'wishlist': Colors.purple,
      'toRead': Colors.blue,
      'reading': Colors.orange,
      'read': Colors.green,
    };

    final total = distribution.values.fold(0, (a, b) => a + b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Distribution',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: distribution.entries.map((entry) {
                    final percentage = (entry.value / total * 100).round();
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: '$percentage%',
                      color: colors[entry.key] ?? Colors.grey,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legend
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: distribution.entries.map((entry) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors[entry.key] ?? Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('${_formatLabel(entry.key)}: ${entry.value}'),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLabel(String key) {
    return switch (key) {
      'wishlist' => 'Wishlist',
      'toRead' => 'To Read',
      'reading' => 'Reading',
      'read' => 'Read',
      _ => key,
    };
  }
}
```

---

## Testing Strategy

### Unit Tests

- [ ] ReadingStats calculation for different time periods
- [ ] DiversityStats.calculateScore formula
- [ ] Shannon entropy calculation
- [ ] Database queries return correct counts

### Widget Tests

- [ ] InsightsScreen renders all sections
- [ ] TimePeriodPicker updates provider
- [ ] HeroStatsCard displays 4 metrics
- [ ] Charts render with sample data

### Integration Tests

- [ ] Add books → Stats update correctly
- [ ] Change time period → Data filters correctly

---

## Files to Create

| File | Type | Description |
|------|------|-------------|
| `lib/features/insights/models/reading_stats.dart` | Model | Stats data models |
| `lib/features/insights/providers/stats_providers.dart` | Provider | Stats providers |
| `lib/features/insights/screens/insights_screen.dart` | Screen | Main insights UI |
| `lib/features/insights/widgets/hero_stats_card.dart` | Widget | Key metrics card |
| `lib/features/insights/widgets/status_distribution_chart.dart` | Widget | Pie chart |
| `lib/features/insights/widgets/cultural_regions_chart.dart` | Widget | Bar chart |
| `lib/features/insights/widgets/gender_donut_chart.dart` | Widget | Donut chart |
| `lib/features/insights/widgets/language_tag_cloud.dart` | Widget | Tag cloud |
| `lib/features/insights/widgets/currently_reading_list.dart` | Widget | Reading list |

---

## Next Steps

After implementing Insights:
1. **07-SETTINGS.md** - App settings and theme selection
2. Refine charts and add animations

---

**Document Status:** Ready for Implementation
**Last Updated:** December 26, 2025
