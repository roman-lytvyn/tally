import 'package:flutter/material.dart';

class AppTheme {
  final bool isDark;
  const AppTheme(this.isDark);

  Color get bg    => isDark ? const Color(0xFF111118) : const Color(0xFFF2F2F7);
  Color get bg2   => isDark ? const Color(0xFF1A1A2F) : const Color(0xFFE5E5ED);
  Color get surf  => isDark ? const Color(0x0EFFFFFF) : const Color(0x0D000000);
  Color get surf2 => isDark ? const Color(0x17FFFFFF) : const Color(0x17000000);
  Color get bdr   => isDark ? const Color(0x14FFFFFF) : const Color(0x17000000);
  Color get tx    => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF111111);
  Color get tx2   => isDark ? const Color(0xFFAAAAAA) : const Color(0xFF666666);
  Color get tx3   => isDark ? const Color(0xFF555555) : const Color(0xFFBBBBBB);
  Color get acc   => isDark ? const Color(0xFFC5A453) : const Color(0xFF8F6520);
  Color get t0    => isDark ? const Color(0xFFC5A453) : const Color(0xFF8F6520);
  Color get t1    => isDark ? const Color(0xFF5A9FD4) : const Color(0xFF1A6FB5);
  Color get danger => isDark ? const Color(0xFFE05252) : const Color(0xFFC0392B);
  Color get egg   => isDark ? const Color(0xFFF0B429) : const Color(0xFFB07800);

  Color get t2    => isDark ? const Color(0xFF6DBE7A) : const Color(0xFF2E7D3E);
  Color teamColor(int i) => [t0, t1, t2][i];
  Color teamDim(int i)   => teamColor(i).withValues(alpha: 0.13);
  Color get accDim  => acc.withValues(alpha: 0.16);
  Color get accBdr  => acc.withValues(alpha: 0.45);
  Color get dangerDim => danger.withValues(alpha: 0.12);
  Color get eggDim  => egg.withValues(alpha: 0.13);
  Color get nk      => isDark ? const Color(0x12FFFFFF) : const Color(0x0F000000);
  Color get nkDel   => isDark ? const Color(0x1FE05252) : const Color(0x18C0392B);

  LinearGradient get setupGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bg2, bg],
    stops: const [0.0, 0.55],
  );

  LinearGradient get headerGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bg2, bg],
  );

  LinearGradient get ctaGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC5A453), Color(0xFFE0C070)],
  );
}
