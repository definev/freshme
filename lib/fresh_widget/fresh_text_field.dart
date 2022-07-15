import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FreshTextField extends StatelessWidget {
  const FreshTextField({
    super.key,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.focusNode,
    this.obscureText = false,
    this.hintText,
    this.labelText,
    this.errorText,
    this.autofocus = false,
    this.autocorrect = false,
    this.borderRadius,
  });

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool obscureText;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool autofocus;
  final bool autocorrect;
  final SmoothBorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (borderRadius != null) {
      return SizedBox(
        height: 48,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 2,
              bottom: -3.5,
              left: 2,
              right: -3.5,
              child: ClipSmoothRect(
                radius: borderRadius!,
                child: ColoredBox(color: theme.colorScheme.secondary),
              ),
            ),
            Positioned.fill(
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                focusNode: focusNode,
                obscureText: obscureText,
                autofocus: autofocus,
                autocorrect: autocorrect,
                decoration: InputDecoration(
                  labelText: labelText,
                  hintText: hintText,
                  fillColor: theme.colorScheme.surface,
                  enabledBorder: InputSmoothRectangleBorder(
                    borderRadius: borderRadius!,
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: InputSmoothRectangleBorder(
                    borderRadius: borderRadius!,
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 3,
            bottom: -3,
            left: 3,
            right: -3,
            child: ColoredBox(color: theme.colorScheme.primary),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(
                  color: theme.colorScheme.onSurface,
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                focusNode: focusNode,
                obscureText: obscureText,
                autofocus: autofocus,
                autocorrect: autocorrect,
                decoration: InputDecoration(
                  labelText: labelText,
                  hintText: hintText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputSmoothRectangleBorder extends InputBorder {
  const InputSmoothRectangleBorder({
    BorderSide borderSide = BorderSide.none,
    this.borderRadius = SmoothBorderRadius.zero,
    this.borderAlign = BorderAlign.inside,
  }) : super(borderSide: borderSide);

  /// The radius for each corner.
  ///
  /// Negative radius values are clamped to 0.0 by [getInnerPath] and
  /// [getOuterPath].
  final SmoothBorderRadius borderRadius;
  final BorderAlign borderAlign;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderSide.width);

  @override
  ShapeBorder scale(double t) {
    return InputSmoothRectangleBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is InputSmoothRectangleBorder) {
      return InputSmoothRectangleBorder(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        borderRadius: SmoothBorderRadius.lerp(a.borderRadius, borderRadius, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is InputSmoothRectangleBorder) {
      return InputSmoothRectangleBorder(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        borderRadius: SmoothBorderRadius.lerp(borderRadius, b.borderRadius, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final innerRect = () {
      switch (borderAlign) {
        case BorderAlign.inside:
          return rect.deflate(borderSide.width);
        case BorderAlign.center:
          return rect.deflate(borderSide.width / 2);
        case BorderAlign.outside:
          return rect;
      }
    }();
    final radius = () {
      switch (borderAlign) {
        case BorderAlign.inside:
          return borderRadius -
              SmoothBorderRadius.all(
                SmoothRadius(
                  cornerRadius: borderSide.width,
                  cornerSmoothing: 1.0,
                ),
              );
        case BorderAlign.center:
          return borderRadius -
              SmoothBorderRadius.all(
                SmoothRadius(
                  cornerRadius: borderSide.width / 2,
                  cornerSmoothing: 1.0,
                ),
              );
        case BorderAlign.outside:
          return borderRadius;
      }
    }();

    if ([radius.bottomLeft, radius.bottomRight, radius.topLeft, radius.topRight]
        .every((x) => x.cornerSmoothing == 0.0)) {
      return Path()..addRRect(radius.resolve(textDirection).toRRect(innerRect));
    }

    return radius.toPath(innerRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final outerRect = () {
      switch (borderAlign) {
        case BorderAlign.inside:
          return rect;
        case BorderAlign.center:
          return rect.inflate(borderSide.width / 2);
        case BorderAlign.outside:
          return rect.inflate(borderSide.width);
      }
    }();
    final radius = () {
      switch (borderAlign) {
        case BorderAlign.inside:
          return borderRadius;
        case BorderAlign.center:
          return borderRadius +
              SmoothBorderRadius.all(
                SmoothRadius(
                  cornerRadius: borderSide.width / 2,
                  cornerSmoothing: 1.0,
                ),
              );
        case BorderAlign.outside:
          return borderRadius +
              SmoothBorderRadius.all(
                SmoothRadius(
                  cornerRadius: borderSide.width,
                  cornerSmoothing: 1.0,
                ),
              );
      }
    }();

    if ([radius.bottomLeft, radius.bottomRight, radius.topLeft, radius.topRight]
        .every((x) => x.cornerSmoothing == 0.0)) {
      return Path()..addRRect(radius.resolve(textDirection).toRRect(outerRect));
    }

    return radius.toPath(outerRect);
  }

  @override
  InputSmoothRectangleBorder copyWith({
    BorderSide? borderSide,
    SmoothBorderRadius? borderRadius,
    BorderAlign? borderAlign,
  }) {
    return InputSmoothRectangleBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      borderAlign: borderAlign ?? this.borderAlign,
    );
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    if (rect.isEmpty) return;
    switch (borderSide.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final outerPath = getOuterPath(
          rect,
          textDirection: textDirection,
        );

        final paint = borderSide.toPaint();

        canvas.drawPath(outerPath, paint);

        break;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is InputSmoothRectangleBorder &&
        other.borderSide == borderSide &&
        other.borderRadius == borderRadius &&
        other.borderAlign == borderAlign;
  }

  @override
  int get hashCode => Object.hash(borderSide, borderRadius, borderAlign);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'InputSmoothRectangleBorder')}($borderSide, $borderRadius, $borderAlign)';
  }

  @override
  bool get isOutline => false;
}
