import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../controller/urdu_typing_controller.dart';
import '../model/typing_durations.dart';
import '../model/typing_screen_phase.dart';
import 'widgets/urdu_style_live_view.dart';
import 'widgets/urdu_style_result_view.dart';
import 'widgets/urdu_style_setup_panel.dart';

/// Urdu Typing Test screen. Same three-phase shape as the English
/// `TypingTestView`, driven by [UrduTypingController] and the shared
/// Urdu-style widgets (also used by PPSC).
class UrduTypingTestView extends GetView<UrduTypingController> {
  const UrduTypingTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.urduTypingTest,
      body: Obx(() {
        switch (controller.screenPhase.value) {
          case TypingScreenPhase.setup:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: UrduStyleSetupPanel(
                    controller: controller,
                    title: 'Urdu Typing Test',
                    subtitle:
                        'اپنی رفتار اور درستگی جانچنے کے لیے پیراگراف اور دورانیہ منتخب کریں۔',
                    durationPresets: TypingDurations.presets,
                  ),
                ),
                TextButton.icon(
                  // Replace (not push) - mirrors the English screen's switch.
                  onPressed: () => Get.offNamed(AppRoutes.typingTest),
                  icon: const Icon(Icons.language, size: 18),
                  label: const Text('Switch to English Test'),
                ),
              ],
            );
          case TypingScreenPhase.test:
            return UrduStyleLiveScreen(controller: controller);
          case TypingScreenPhase.result:
            return UrduStyleResultScreen(
              controller: controller,
              title: 'ٹیسٹ مکمل ہوا',
              backLabel: 'Back to Setup',
              onBackPressed: controller.backToSetupFromResult,
            );
        }
      }),
    );
  }
}
