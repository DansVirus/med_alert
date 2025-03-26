// import 'package:flutter/material.dart';
//
// import '../l10n/app_localization.dart';
// import '../screens/settings_screen.dart';
//
// AppBar customAppbar(BuildContext context) {
//   bool isDark = Theme.of(context).brightness == Brightness.dark;
//   return AppBar(
//     toolbarHeight: 60,
//     titleSpacing: 0,
//     flexibleSpace: Container(
//       decoration: BoxDecoration(
//         border: Border(
//           top: BorderSide(),
//           bottom: BorderSide(),
//         ),
//       ),
//     ),
//     title: Container(
//       padding: EdgeInsets.all(2),
//       height: 55,
//       width: double.infinity, // Expands to the full width of the screen
//       child: Center(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(isDark ? 'assets/icon_foreground_dark.png' : 'assets/icon_foreground.png'),
//             const SizedBox(width: 8), // Add spacing between the image and text
//             Text(
//               'MedAlert',
//               style: TextStyle(
//                 color: Theme.of(context).appBarTheme.titleTextStyle!.color,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//       actions: [
//         Semantics(
//           label: AppLocalizations.of(context)!
//               .translate('settings_label'),
//           hint: AppLocalizations.of(context)!
//               .translate('settings_hint'),
//           excludeSemantics: true,
//           button: true,
//           child: IconButton(
//             tooltip: 'settings',
//             icon: const Icon(Icons.settings),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SettingsPage()),
//             ),
//           ),
//         ),
//       ],
//   );
// }

import 'package:flutter/material.dart';
import '../l10n/app_localization.dart';
import '../screens/settings_screen.dart';

AppBar customAppbar(BuildContext context) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  final titleStyle =
      Theme.of(context).appBarTheme.titleTextStyle ??
      Theme.of(context).textTheme.titleLarge ??
      const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );

  return AppBar(
    toolbarHeight: 60,
    titleSpacing: 0,
    title: Container(
      padding: const EdgeInsets.all(2),
      height: 55,
      width: double.infinity,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              isDark
                  ? 'assets/icon_foreground_dark.png'
                  : 'assets/icon_foreground.png',
              height: 40,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(Icons.error),
            ),
            const SizedBox(width: 8),
            Text(
              'MedAlert',
              style: const TextStyle(
                // fallback for tests
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      Semantics(
        label: AppLocalizations.of(context)!.translate('settings_label'),
        hint: AppLocalizations.of(context)!.translate('settings_hint'),
        excludeSemantics: true,
        button: true,
        child: IconButton(
          tooltip: 'settings',
          icon: const Icon(Icons.settings),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
        ),
      ),
    ],
  );
}
