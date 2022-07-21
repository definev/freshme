import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Future<T?> showFreshModalBottomSheet<T>(
  BuildContext context, {
  required Widget child,
  Color? backgroundColor,
  String? barrierAction,
  VoidCallback? onClosing,
}) async =>
    Navigator.push(
      context,
      _FreshModalBottomSheet<T>(
        backgroundColor: backgroundColor,
        barrierAction: barrierAction,
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        onClosing: onClosing,
        child: child,
      ),
    );

class _FreshModalBottomSheet<T> extends PopupRoute<T> {
  _FreshModalBottomSheet({
    super.filter,
    this.backgroundColor,
    this.barrierAction,
    this.onClosing,
    required this.child,
  });

  final Color? backgroundColor;
  final String? barrierAction;
  final VoidCallback? onClosing;
  final Widget child;

  @override
  Color? get barrierColor => backgroundColor ?? Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => barrierAction ?? 'Bottom Sheet Action';

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);

    _animationController = BottomSheet.createAnimationController(navigator!);
    return _animationController!;
  }

  final _slideTween = TweenSequence<Offset>(
    [
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.9))
            .chain(CurveTween(curve: Curves.decelerate)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.0, 0.9), end: const Offset(0.0, 0.0))
            .chain(CurveTween(curve: Curves.fastOutSlowIn)),
        weight: 70,
      ),
    ],
  );

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final slideAnimation = _slideTween.animate(animation);
    final bottomSheet = BottomSheet(
      animationController: _animationController,
      onClosing: () {
        onClosing?.call();
        Navigator.pop(context);
      },
      backgroundColor: Colors.transparent,
      builder: (context) => child,
    );

    return SlideTransition(
      position: slideAnimation,
      child: bottomSheet,
    );
  }

  @override
  Duration get transitionDuration => 300.ms;
}
