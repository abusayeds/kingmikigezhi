import 'package:event_sharing/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// Standard pull-to-refresh wrapper for list / scroll pages.
///
/// Pair with a scrollable that uses [AlwaysScrollableScrollPhysics]
/// (or [PullToRefresh.alwaysScrollable]) so empty/short content still refreshes.
class PullToRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final Color? color;

  const PullToRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
  });

  /// Use on ListView / SingleChildScrollView so pull works when content is short.
  static ScrollPhysics alwaysScrollable([ScrollPhysics? parent]) =>
      AlwaysScrollableScrollPhysics(
          parent: parent ?? const ClampingScrollPhysics());

  /// Empty-state that can still be pulled to refresh.
  static Widget empty({
    required Future<void> Function() onRefresh,
    required Widget child,
    Color? color,
  }) {
    return PullToRefresh(
      onRefresh: onRefresh,
      color: color,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: alwaysScrollable(),
            children: [
              SizedBox(
                height: constraints.maxHeight,
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: color ?? AppColors.primaryColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
