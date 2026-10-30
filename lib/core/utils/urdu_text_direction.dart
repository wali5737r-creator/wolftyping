import 'package:flutter/widgets.dart';

import '../../features/settings/controller/settings_controller.dart';

/// Direction for Urdu typing text, from Settings > Urdu RTL display.
/// Right-to-left (the natural direction) unless the user turned it off.
TextDirection urduTextDirection() =>
    (SettingsController.currentOrNull?.urduRtl ?? true)
        ? TextDirection.rtl
        : TextDirection.ltr;
