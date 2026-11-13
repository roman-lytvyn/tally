import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The channel through which the desktop runners set their window title.
const _windowChannel = MethodChannel('tally/window');

/// Shows [title] in the title bar of the desktop window the app runs in, and
/// keeps it in step when the title changes, for example with the language.
///
/// The web and mobile platforms already take the app's name from [Title], so
/// there it does nothing.
class WindowTitle extends StatefulWidget {
  final String title;
  final Widget child;
  const WindowTitle({super.key, required this.title, required this.child});

  @override
  State<WindowTitle> createState() => _WindowTitleState();
}

class _WindowTitleState extends State<WindowTitle> {
  @override
  void initState() {
    super.initState();
    _apply();
  }

  @override
  void didUpdateWidget(WindowTitle old) {
    super.didUpdateWidget(old);
    if (old.title != widget.title) _apply();
  }

  void _apply() {
    if (kIsWeb) return;
    if (defaultTargetPlatform != TargetPlatform.windows &&
        defaultTargetPlatform != TargetPlatform.linux) {
      return;
    }
    // A runner without the channel, such as the test environment, keeps its
    // own title.
    _windowChannel.invokeMethod<void>('setTitle', widget.title).catchError((Object _) {});
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
