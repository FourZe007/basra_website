import 'package:flutter/material.dart';

/// Legacy constant kept for backward compatibility.
/// Use the responsive helper functions below for new code.
final double screen = 378;

// ─────────────────────────────────────────────────────────────────────────────
// Responsive breakpoints
// ─────────────────────────────────────────────────────────────────────────────

/// Breakpoint below which the layout is treated as mobile (< 600 px).
const double kMobileBreakpoint = 600.0;

/// Breakpoint below which the layout is treated as tablet (< 1024 px).
const double kTabletBreakpoint = 1024.0;

// ─────────────────────────────────────────────────────────────────────────────
// Helper functions — pass [BuildContext] or a raw [double] width
// ─────────────────────────────────────────────────────────────────────────────

/// Returns `true` when the current viewport width is in the **mobile** range
/// (< [kMobileBreakpoint]).
bool isMobile(BuildContext context) =>
    MediaQuery.sizeOf(context).width < kMobileBreakpoint;

/// Returns `true` when the current viewport width is in the **tablet** range
/// ([kMobileBreakpoint] ≤ width < [kTabletBreakpoint]).
bool isTablet(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  return w >= kMobileBreakpoint && w < kTabletBreakpoint;
}

/// Returns `true` when the current viewport width is in the **desktop** range
/// (≥ [kTabletBreakpoint]).
bool isDesktop(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= kTabletBreakpoint;

/// Responsive value selector — returns [mobile], [tablet], or [desktop]
/// depending on the current viewport width.
///
/// [tablet] defaults to [desktop] when not provided.
T responsiveValue<T>(
  BuildContext context, {
  required T mobile,
  T? tablet,
  required T desktop,
}) {
  final w = MediaQuery.sizeOf(context).width;
  if (w < kMobileBreakpoint) return mobile;
  if (w < kTabletBreakpoint) return tablet ?? desktop;
  return desktop;
}
