import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../typing_test/model/typing_screen_phase.dart';
import '../../typing_test/view/widgets/urdu_style_live_view.dart';
import '../../typing_test/view/widgets/urdu_style_result_view.dart';
import '../../typing_test/view/widgets/urdu_style_setup_panel.dart';
import '../controller/ppsc_typing_controller.dart';

/// PPSC Urdu Typing Practice screen. Same three-phase shape and the same
/// shared Urdu-style widgets as the Urdu Typing Test, driven by
/// [PpscTypingController] -- the only real differences are the narrower
/// duration presets (2/5/10 min) and testType = 'ppsc' when saving.
class PpscView extends GetView<PpscTypingController> {
  const PpscView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.ppscUrdu,
      body: Obx(() {
        switch (controller.screenPhase.value) {
          case TypingScreenPhase.setup:
            return Column(
              children: [
                Expanded(
                  child: UrduStyleSetupPanel(
                    controller: controller,
                    title: 'PPSC Urdu Typing Practice',
                    subtitle:
                        'PPSC طرز کے ٹیسٹ کی تیاری کے لیے دورانیہ اور پیراگراف منتخب کریں۔',
                    durationPresets: PpscDurations.presets,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.ppscMockTest),
                      icon: const Icon(Icons.quiz_outlined),
                      label: const Text(
                        'Practice MCQ Mock Test (timed, with result & review)',
                      ),
                    ),
                  ),
                ),
              ],
            );
          case TypingScreenPhase.test:
            return UrduStyleLiveScreen(controller: controller);
          case TypingScreenPhase.result:
            return UrduStyleResultScreen(
              controller: controller,
              title: 'PPSC ٹیسٹ مکمل ہوا',
              backLabel: 'Back to Setup',
              onBackPressed: controller.backToSetupFromResult,
            );
        }
      }),
    );
  }
}
