/// Time range selector for the Progress dashboard (spec section 9).
enum ProgressTimeRange {
  last7Days,
  last30Days,
  last3Months,
  allTime;

  String get label {
    switch (this) {
      case ProgressTimeRange.last7Days:
        return '7 Days';
      case ProgressTimeRange.last30Days:
        return '30 Days';
      case ProgressTimeRange.last3Months:
        return '3 Months';
      case ProgressTimeRange.allTime:
        return 'All Time';
    }
  }

  /// Inclusive start date for this range relative to [now]. Null means no
  /// lower bound (all time).
  DateTime? startDate(DateTime now) {
    final DateTime todayStart = DateTime(now.year, now.month, now.day);
    switch (this) {
      case ProgressTimeRange.last7Days:
        return todayStart.subtract(const Duration(days: 6));
      case ProgressTimeRange.last30Days:
        return todayStart.subtract(const Duration(days: 29));
      case ProgressTimeRange.last3Months:
        return DateTime(now.year, now.month - 3, now.day);
      case ProgressTimeRange.allTime:
        return null;
    }
  }
}

/// Chart language filter (spec section 10): [All] [English] [Urdu] [PPSC].
enum ChartLanguageFilter {
  all,
  english,
  urdu,
  ppsc;

  String get label {
    switch (this) {
      case ChartLanguageFilter.all:
        return 'All';
      case ChartLanguageFilter.english:
        return 'English';
      case ChartLanguageFilter.urdu:
        return 'Urdu';
      case ChartLanguageFilter.ppsc:
        return 'PPSC';
    }
  }
}
