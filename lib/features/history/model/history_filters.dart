/// Language filter for the History screen.
enum HistoryLanguageFilter {
  all,
  english,
  urdu;

  String get label {
    switch (this) {
      case HistoryLanguageFilter.all:
        return 'All';
      case HistoryLanguageFilter.english:
        return 'English';
      case HistoryLanguageFilter.urdu:
        return 'Urdu';
    }
  }
}

/// Test type filter.
enum HistoryTestTypeFilter {
  all,
  normal,
  ppsc;

  String get label {
    switch (this) {
      case HistoryTestTypeFilter.all:
        return 'All';
      case HistoryTestTypeFilter.normal:
        return 'Normal';
      case HistoryTestTypeFilter.ppsc:
        return 'PPSC';
    }
  }
}

/// Duration filter — matches the exact planned duration used for the
/// test; [custom] means "any duration other than these presets".
enum HistoryDurationFilter {
  all,
  seconds30,
  minute1,
  minutes2,
  minutes5,
  minutes10,
  custom;

  String get label {
    switch (this) {
      case HistoryDurationFilter.all:
        return 'All';
      case HistoryDurationFilter.seconds30:
        return '30 seconds';
      case HistoryDurationFilter.minute1:
        return '1 minute';
      case HistoryDurationFilter.minutes2:
        return '2 minutes';
      case HistoryDurationFilter.minutes5:
        return '5 minutes';
      case HistoryDurationFilter.minutes10:
        return '10 minutes';
      case HistoryDurationFilter.custom:
        return 'Custom';
    }
  }

  int? get seconds {
    switch (this) {
      case HistoryDurationFilter.seconds30:
        return 30;
      case HistoryDurationFilter.minute1:
        return 60;
      case HistoryDurationFilter.minutes2:
        return 120;
      case HistoryDurationFilter.minutes5:
        return 300;
      case HistoryDurationFilter.minutes10:
        return 600;
      case HistoryDurationFilter.all:
      case HistoryDurationFilter.custom:
        return null;
    }
  }
}

/// Date range filter, relative to "now" at the moment filters are applied.
enum HistoryDateFilter {
  allTime,
  today,
  last7Days,
  last30Days;

  String get label {
    switch (this) {
      case HistoryDateFilter.allTime:
        return 'All Time';
      case HistoryDateFilter.today:
        return 'Today';
      case HistoryDateFilter.last7Days:
        return 'Last 7 Days';
      case HistoryDateFilter.last30Days:
        return 'Last 30 Days';
    }
  }
}

/// Sort options (spec section 4). Default is [newestFirst].
enum HistorySort {
  newestFirst,
  oldestFirst,
  highestWpm,
  lowestWpm,
  highestAccuracy,
  lowestAccuracy;

  String get label {
    switch (this) {
      case HistorySort.newestFirst:
        return 'Newest First';
      case HistorySort.oldestFirst:
        return 'Oldest First';
      case HistorySort.highestWpm:
        return 'Highest WPM';
      case HistorySort.lowestWpm:
        return 'Lowest WPM';
      case HistorySort.highestAccuracy:
        return 'Highest Accuracy';
      case HistorySort.lowestAccuracy:
        return 'Lowest Accuracy';
    }
  }
}
