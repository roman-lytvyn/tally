import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../l10n.dart';

/// The version the build was given; a local build has none.
const kAppVersion = String.fromEnvironment('APP_VERSION', defaultValue: 'dev');

const _kWebsite = 'tallycards.app';

Future<void> _openInBrowser(Uri url) => launchUrl(url, mode: LaunchMode.externalApplication);

class AboutScreen extends StatelessWidget {
  final AppTheme theme;
  final AppStrings strings;
  final VoidCallback onBack;
  final Future<void> Function(Uri url) openLink;

  const AboutScreen({
    super.key, required this.theme, required this.strings, required this.onBack,
    this.openLink = _openInBrowser,
  });

  AppTheme get t => theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(gradient: t.headerGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                child: Row(children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(color: t.surf, borderRadius: BorderRadius.circular(10)),
                      child: Text(strings.backBtn,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.tx2)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(strings.aboutTitle,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: t.tx)),
                  )),
                ]),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Text(strings.appTitle, textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: t.tx)),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: t.surf, border: Border.all(color: t.bdr),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      _row(strings.versionLabel, kAppVersion, key: const ValueKey('about.version')),
                      Divider(height: 1, color: t.bdr, indent: 15),
                      _row(strings.authorLabel, strings.authorName),
                      Divider(height: 1, color: t.bdr, indent: 15),
                      _row(strings.contactLabel, 'litvin.roma@gmail.com'),
                      Divider(height: 1, color: t.bdr, indent: 15),
                      _linkRow(strings.websiteLabel, _kWebsite, Uri.https(_kWebsite),
                          key: const ValueKey('about.website')),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A caption over a value that can be selected and copied.
  Widget _row(String label, String value, {Key? key}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 12, color: t.tx2)),
      const SizedBox(height: 2),
      SelectableText(value, key: key, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: t.tx)),
    ]),
  );

  /// A caption over a link; the whole row opens it in the browser.
  Widget _linkRow(String label, String text, Uri url, {Key? key}) => Semantics(
    link: true,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: key,
        behavior: HitTestBehavior.opaque,
        onTap: () => openLink(url),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 12, color: t.tx2)),
              const SizedBox(height: 2),
              Text(text, style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: t.acc,
                decoration: TextDecoration.underline, decorationColor: t.acc,
              )),
            ])),
            const SizedBox(width: 10),
            Icon(Icons.open_in_new, size: 18, color: t.acc),
          ]),
        ),
      ),
    ),
  );
}
