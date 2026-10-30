import 'package:get/get.dart';

import '../../features/home/controller/home_controller.dart';
import '../../features/home/view/home_view.dart';

import '../../features/typing_test/controller/typing_controller.dart';
import '../../features/typing_test/controller/urdu_typing_controller.dart';
import '../../features/typing_test/view/typing_test_view.dart';
import '../../features/typing_test/view/urdu_typing_test_view.dart';

import '../../features/lessons/controller/lesson_practice_controller.dart';
import '../../features/lessons/controller/lessons_controller.dart';
import '../../features/lessons/view/lesson_practice_view.dart';
import '../../features/lessons/view/lessons_view.dart';

import '../../features/practice/controller/mistake_practice_controller.dart';
import '../../features/practice/controller/practice_controller.dart';
import '../../features/practice/view/mistake_practice_view.dart';
import '../../features/practice/view/practice_view.dart';

import '../../features/ppsc/controller/custom_sets_controller.dart';
import '../../features/ppsc/controller/mock_test_controller.dart';
import '../../features/ppsc/controller/ppsc_typing_controller.dart';
import '../../features/ppsc/view/custom_set_editor_view.dart';
import '../../features/ppsc/view/custom_tests_view.dart';
import '../../features/ppsc/view/mock_test_view.dart';
import '../../features/ppsc/view/papers_list_view.dart';
import '../../features/ppsc/view/ppsc_view.dart';

import '../../features/paragraphs/controller/paragraph_form_controller.dart';
import '../../features/paragraphs/controller/paragraphs_controller.dart';
import '../../features/paragraphs/view/paragraph_form_view.dart';
import '../../features/paragraphs/view/paragraph_preview_view.dart';
import '../../features/paragraphs/view/paragraphs_view.dart';

import '../../features/history/controller/history_controller.dart';
import '../../features/history/view/history_detail_view.dart';
import '../../features/history/view/history_view.dart';

import '../../features/progress/controller/progress_controller.dart';
import '../../features/progress/view/progress_view.dart';

import '../../features/profile/controller/profile_controller.dart';
import '../../features/profile/view/profile_view.dart';

import '../../features/settings/view/settings_view.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // Dashboard
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),

    // English Typing Test
    GetPage(
      name: AppRoutes.typingTest,
      page: () => const TypingTestView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TypingController>(() => TypingController());
      }),
    ),

    // Urdu Typing Test
    GetPage(
      name: AppRoutes.urduTypingTest,
      page: () => const UrduTypingTestView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UrduTypingController>(
          () => UrduTypingController(),
        );
      }),
    ),

    // Lessons
    GetPage(
      name: AppRoutes.lessons,
      page: () => const LessonsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LessonsController>(
          () => LessonsController(),
        );
      }),
    ),

    // Lesson Practice
    GetPage(
      name: AppRoutes.lessonPractice,
      page: () => const LessonPracticeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LessonPracticeController>(
          () => LessonPracticeController(),
        );
      }),
    ),

    // Practice
    GetPage(
      name: AppRoutes.practice,
      page: () => const PracticeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PracticeController>(
          () => PracticeController(),
        );
      }),
    ),

    // Mistake Practice
    GetPage(
      name: AppRoutes.mistakePractice,
      page: () => const MistakePracticeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MistakePracticeController>(
          () => MistakePracticeController(),
        );
      }),
    ),

    // Mistake Analysis
    GetPage(
      name: AppRoutes.mistakeAnalysis,
      page: () => const PracticeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PracticeController>(
          () => PracticeController(),
        );
      }),
    ),

    // Keyboard Heatmap
    GetPage(
      name: AppRoutes.keyboardHeatmap,
      page: () => const PracticeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PracticeController>(
          () => PracticeController(),
        );
      }),
    ),

    // PPSC Urdu
    GetPage(
      name: AppRoutes.ppscUrdu,
      page: () => const PpscView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PpscTypingController>(
          () => PpscTypingController(),
        );
      }),
    ),

    // PPSC Practice MCQ Mock Test
    GetPage(
      name: AppRoutes.ppscMockTest,
      page: () => const MockTestView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MockTestController>(() => MockTestController());
      }),
    ),

    // 2026 practice papers list (practice material only)
    GetPage(
      name: AppRoutes.ppscPastPapers,
      page: () => const PapersListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MockTestController>(() => MockTestController());
      }),
    ),

    // Teacher-created custom MCQ tests (user-created, practice-only)
    GetPage(
      name: AppRoutes.ppscCustomTests,
      page: () => const CustomTestsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CustomSetsController>(() => CustomSetsController());
        Get.lazyPut<MockTestController>(() => MockTestController());
      }),
    ),

    // Custom test create/edit screen (argument: the CustomSet to edit,
    // or null for a new set)
    GetPage(
      name: AppRoutes.ppscCustomTestEditor,
      page: () => const CustomSetEditorView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CustomSetsController>(() => CustomSetsController());
      }),
    ),

    // My Paragraphs
    GetPage(
      name: AppRoutes.myParagraphs,
      page: () => const ParagraphsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ParagraphsController>(
          () => ParagraphsController(),
        );
      }),
    ),

    // Paragraph Form
    GetPage(
      name: AppRoutes.paragraphForm,
      page: () => const ParagraphFormView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ParagraphFormController>(
          () => ParagraphFormController(),
        );
      }),
    ),

    // Paragraph Preview
    GetPage(
      name: AppRoutes.paragraphPreview,
      page: () => const ParagraphPreviewView(),
    ),

    // History
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HistoryController>(
          () => HistoryController(),
        );
      }),
    ),

    // History Detail
    GetPage(
      name: AppRoutes.historyDetail,
      page: () => const HistoryDetailView(),
    ),

    // Progress
    GetPage(
      name: AppRoutes.progress,
      page: () => const ProgressView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProgressController>(
          () => ProgressController(),
        );
      }),
    ),

    // Profile
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProfileController>(
          () => ProfileController(),
        );
      }),
    ),

    // Settings
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      // SettingsController is registered once, app-wide, in main.dart.
    ),
  ];
}