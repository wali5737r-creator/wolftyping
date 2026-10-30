import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../controller/typing_controller.dart';
import 'widgets/typing_live_view.dart';
import 'widgets/typing_result_view.dart';
import 'widgets/typing_setup_panel.dart';

/// English Typing Test screen. Three phases share one route:
/// setup -> test -> result -- see [TypingScreenPhase] on [TypingController].
class TypingTestView extends GetView<TypingController> {
  const TypingTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.typingTest,
      body: Obx(() {
        switch (controller.screenPhase.value) {
          case TypingScreenPhase.setup:
            return TypingSetupPanel(controller: controller);
          case TypingScreenPhase.test:
            return TypingLiveScreen(controller: controller);
          case TypingScreenPhase.result:
            return TypingResultScreen(controller: controller);
        }
      }),
    );
  }
}
