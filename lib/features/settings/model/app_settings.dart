import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.showLiveWpm,
    required this.showLiveAccuracy,
    required this.showErrors,
    required this.autoScroll,
    required this.countBackspaces,
    required this.strictSkipDetection,
    required this.defaultDurationSeconds,
    required this.defaultLanguage,
    required this.defaultTestType,
    required this.autoFocus,
    required this.showTimer,
    required this.allowBackspace,
    required this.urduRtl,
    required this.practiceDifficulty,
    required this.dailyGoalSeconds,
  });

  final ThemeMode themeMode;
  final bool showLiveWpm, showLiveAccuracy, showErrors, autoScroll, countBackspaces, strictSkipDetection;
  final int defaultDurationSeconds, dailyGoalSeconds;
  final String defaultLanguage, defaultTestType, practiceDifficulty;
  final bool autoFocus, showTimer, allowBackspace, urduRtl;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? showLiveWpm,
    bool? showLiveAccuracy,
    bool? showErrors,
    bool? autoScroll,
    bool? countBackspaces,
    bool? strictSkipDetection,
    int? defaultDurationSeconds,
    String? defaultLanguage,
    String? defaultTestType,
    bool? autoFocus,
    bool? showTimer,
    bool? allowBackspace,
    bool? urduRtl,
    String? practiceDifficulty,
    int? dailyGoalSeconds,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        showLiveWpm: showLiveWpm ?? this.showLiveWpm,
        showLiveAccuracy: showLiveAccuracy ?? this.showLiveAccuracy,
        showErrors: showErrors ?? this.showErrors,
        autoScroll: autoScroll ?? this.autoScroll,
        countBackspaces: countBackspaces ?? this.countBackspaces,
        strictSkipDetection: strictSkipDetection ?? this.strictSkipDetection,
        defaultDurationSeconds:
            defaultDurationSeconds ?? this.defaultDurationSeconds,
        defaultLanguage: defaultLanguage ?? this.defaultLanguage,
        defaultTestType: defaultTestType ?? this.defaultTestType,
        autoFocus: autoFocus ?? this.autoFocus,
        showTimer: showTimer ?? this.showTimer,
        allowBackspace: allowBackspace ?? this.allowBackspace,
        urduRtl: urduRtl ?? this.urduRtl,
        practiceDifficulty: practiceDifficulty ?? this.practiceDifficulty,
        dailyGoalSeconds: dailyGoalSeconds ?? this.dailyGoalSeconds,
      );
}
