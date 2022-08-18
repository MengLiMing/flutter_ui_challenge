import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogUtils {
  static Future<T?> showBottomSheet<T extends Object?>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) async {
    return showModalBottomSheet(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        final child = builder(context);
        return Material(
          child: SafeArea(
            child: child,
          ),
        );
      },
    );
  }

  static Future<T?> show<T extends Object?>(
    BuildContext context, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    required WidgetBuilder builder,
    RouteTransitionsBuilder? transitionBuilder,
  }) async {
    return showGeneralDialog<T>(
      context: context,
      transitionDuration: duration,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, _, __) {
        final child = builder(context);
        return Material(
          type: MaterialType.transparency,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: MediaQuery(
                data: MediaQuery.of(context).removePadding(
                  removeTop: true,
                  removeBottom: true,
                ),
                child: child),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curveAnimation = CurvedAnimation(parent: animation, curve: curve);
        final secondCurveAnimation =
            CurvedAnimation(parent: secondaryAnimation, curve: curve);
        if (transitionBuilder == null) {
          return defaultTransitions(
              context, curveAnimation, secondCurveAnimation, child);
        } else {
          return transitionBuilder(
              context, curveAnimation, secondCurveAnimation, child);
        }
      },
    );
  }

  /// 默认动画
  static RouteTransitionsBuilder get defaultTransitions =>
      (context, animation, secondaryAnimation, child) {
        final opciatyTween = Tween<double>(begin: 0.5, end: 1);
        final offsetTween = Tween<Offset>(
          begin: const Offset(0, 0.6),
          end: const Offset(0, 0),
        );
        return FadeTransition(
          opacity: opciatyTween.animate(animation),
          child: SlideTransition(
            position: offsetTween.animate(animation),
            child: child,
          ),
        );
      };

  /// 无动画
  static RouteTransitionsBuilder get noAnimation =>
      (context, animation, secondaryAnimation, child) => child;
}
