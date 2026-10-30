import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import 'app_sidebar.dart';

/// The shared desktop shell: a persistent [AppSidebar] on the left and a
/// content area on the right. Every feature page wraps its body with this
/// so the sidebar never has to be rebuilt/duplicated per feature.
///
/// The Typing Test screen (and other content that wants full control, e.g.
/// no scrolling/padding) can pass [padContent] = false and manage its own
/// layout — spec section 9/59 requires the typing area to get the largest
/// share of space with no forced scaffolding around it.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.currentRoute,
    required this.body,
    this.padContent = true,
  });

  final String currentRoute;
  final Widget body;
  final bool padContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSidebar(currentRoute: currentRoute),
          Expanded(
            child: padContent
                ? Padding(
                    padding: const EdgeInsets.all(AppDimensions.pagePadding),
                    child: body,
                  )
                : body,
          ),
        ],
      ),
    );
  }
}
