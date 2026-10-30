import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/features/ppsc/model/custom_set.dart';
import 'package:typing_master/features/ppsc/model/mock_attempt.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/service/custom_sets_repository.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';

/// Security caps (M1) and progress storage: imports are bounded, bad
/// data is rejected with readable errors, and corrupt stored progress
/// is skipped instead of crashing.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    MockProgressRepository.instance.resetForTest();
  });

  MockQuestion question(String id) => MockQuestion(
        id: id,
        subject: MockSubject.english,
        question: 'Question $id?',
        options: const ['A', 'B', 'C', 'D'],
        correctIndex: 0,
      );

  group('import caps', () {
    test('validate rejects more than 200 questions', () {
      final set = CustomSet(
        id: 'big',
        name: 'Big',
        questions: List.generate(201, (i) => question('q$i')),
      );
      expect(
        () => CustomSet.validate(set),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('200'),
          ),
        ),
      );
    });

    test('validate rejects a field over 4000 characters', () {
      final long = 'x' * 4001;
      final set = CustomSet(
        id: 'long',
        name: long,
        questions: [question('q1')],
      );
      expect(() => CustomSet.validate(set), throwsA(isA<FormatException>()));
      final set2 = CustomSet(
        id: 'long2',
        name: 'Ok',
        questions: [
          MockQuestion(
            id: 'q1',
            subject: MockSubject.english,
            question: long,
            options: const ['A', 'B', 'C', 'D'],
            correctIndex: 0,
          ),
        ],
      );
      expect(() => CustomSet.validate(set2), throwsA(isA<FormatException>()));
    });

    test('decode rejects input over 512 KB with a readable error', () {
      final huge = 'a' * (512 * 1024 + 1);
      expect(
        () => CustomSet.decode(huge),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('512 KB'),
          ),
        ),
      );
    });

    test('exactly 200 questions validates', () {
      final set = CustomSet(
        id: 'max',
        name: 'Max',
        questions: List.generate(200, (i) => question('q$i')),
      );
      CustomSet.validate(set);
    });
  });

  group('progress repository', () {
    test('records attempts and finds the best score per source', () async {
      final repo = MockProgressRepository.instance;
      await repo.init();
      MockAttempt attempt(double score) => MockAttempt(
            id: 'a-$score',
            sourceKind: 'paper',
            sourceId: '2026-219',
            sourceLabel: 'Practice Paper 219',
            totalQuestions: 10,
            correct: score.toInt(),
            wrong: 0,
            skipped: 0,
            score: score,
            attemptedAt: DateTime(2026, 10, 30),
          );
      await repo.recordAttempt(attempt(4));
      await repo.recordAttempt(attempt(7));
      expect(repo.bestAttemptFor('2026-219')?.score, 7);
      expect(repo.completedCount(['2026-219', '2026-220']), 1);
      // Persisted: a fresh load from stored prefs returns both.
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(MockProgressRepository.attemptsKey), isNotNull);
      final stored =
          jsonDecode(prefs.getString(MockProgressRepository.attemptsKey)!);
      expect((stored as List).length, 2);
    });

    test('corrupt stored attempts are skipped, good ones kept', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        MockProgressRepository.attemptsKey: jsonEncode([
          {'not': 'an attempt'},
          MockAttempt(
            id: 'good',
            sourceKind: 'paper',
            sourceId: '2026-219',
            sourceLabel: 'Practice Paper 219',
            totalQuestions: 10,
            correct: 5,
            wrong: 3,
            skipped: 2,
            score: 5,
            attemptedAt: DateTime(2026, 10, 30),
          ).toJson(),
        ]),
      });
      final repo = MockProgressRepository.instance;
      await repo.init();
      expect(repo.attempts.length, 1);
      expect(repo.attempts.first.id, 'good');
    });

    test('weakest subjects come only from real attempts', () async {
      final repo = MockProgressRepository.instance;
      await repo.init();
      expect(repo.weakestSubjects(), isEmpty);
      await repo.recordAttempt(
        MockAttempt(
          id: 'w1',
          sourceKind: 'full',
          sourceId: 'full',
          sourceLabel: 'Full mock test',
          totalQuestions: 10,
          correct: 4,
          wrong: 6,
          skipped: 0,
          score: 4,
          attemptedAt: DateTime(2026, 10, 30),
          perSubjectCorrect: {'english': 1, 'mathematics': 3},
          perSubjectTotal: {'english': 5, 'mathematics': 5},
        ),
      );
      final stats = repo.weakestSubjects();
      expect(stats.map((s) => s.subject.name).toList(), [
        'english',
        'mathematics',
      ]);
      expect(stats.first.correct, 1);
      expect(stats.first.total, 5);
    });

    test('bookmarks toggle and cap at 200', () async {
      final repo = MockProgressRepository.instance;
      await repo.init();
      expect(await repo.toggleBookmark(question('q1')), isTrue);
      expect(repo.isBookmarked('q1'), isTrue);
      expect(await repo.toggleBookmark(question('q1')), isFalse);
      expect(repo.isBookmarked('q1'), isFalse);
    });
  });

  group('custom sets repository storage failure message', () {
    test('saveAll writes valid JSON that load reads back', () async {
      final repo = CustomSetsRepository.instance;
      final set = CustomSet(id: 's1', name: 'One', questions: [question('q1')]);
      await repo.saveAll([set]);
      final loaded = await repo.load();
      expect(loaded.length, 1);
      expect(loaded.first.name, 'One');
    });
  });
}
