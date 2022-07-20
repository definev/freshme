import 'dart:math' as math;
import 'dart:ui';
import 'package:vector_math/vector_math.dart' as vector;

import 'package:figma_squircle/figma_squircle.dart';

class ProcessedSmoothRadius {
  const ProcessedSmoothRadius._({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.p,
    required this.width,
    required this.height,
    required this.radius,
    required this.circularSectionLength,
  });

  factory ProcessedSmoothRadius(
    SmoothRadius radius, {
    required double width,
    required double height,
  }) {
    final cornerSmoothing = radius.cornerSmoothing;
    var cornerRadius = radius.cornerRadius;

    final maxRadius = math.min(width, height) / 2;
    cornerRadius = math.min(cornerRadius, maxRadius);

    // 12.2 from the article
    final p = math.min((1 + cornerSmoothing) * cornerRadius, maxRadius);

    final double angleAlpha, angleBeta;

    if (cornerRadius <= maxRadius / 2) {
      angleBeta = 90 * (1 - cornerSmoothing);
      angleAlpha = 45 * cornerSmoothing;
    } else {
      // When `cornerRadius` is larger and `maxRadius / 2`,
      // these angles also depend on `cornerRadius` and `maxRadius / 2`
      //
      // I did a few tests in Figma and this code generated similar but not identical results
      // `diffRatio` was called `change_percentage` in the orignal code
      final diffRatio = (cornerRadius - maxRadius / 2) / (maxRadius / 2);

      angleBeta = 90 * (1 - cornerSmoothing * (1 - diffRatio));
      angleAlpha = 45 * cornerSmoothing * (1 - diffRatio);
    }

    final angleTheta = (90 - angleBeta) / 2;

    // This was called `h_longest` in the original code
    // In the article this is the distance between 2 control points: P3 and P4
    final p3ToP4Distance =
        cornerRadius * math.tan(vector.radians(angleTheta / 2));

    // This was called `l` in the original code
    final circularSectionLength =
        math.sin(vector.radians(angleBeta / 2)) * cornerRadius * math.sqrt(2);

    // a, b, c and d are from 11.1 in the article
    final c = p3ToP4Distance * math.cos(vector.radians(angleAlpha));
    final d = c * math.tan(vector.radians(angleAlpha));
    final b = (p - circularSectionLength - c - d) / 3;
    final a = 2 * b;

    return ProcessedSmoothRadius._(
      a: a,
      b: b,
      c: c,
      d: d,
      p: p,
      width: width,
      height: height,
      radius: radius,
      circularSectionLength: circularSectionLength,
    );
  }

  final SmoothRadius radius;
  final double a;
  final double b;
  final double c;
  final double d;
  final double p;
  final double circularSectionLength;
  final double width;
  final double height;
  double get cornerRadius => radius.cornerRadius;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    if (other is SmoothRadius) {
      return other == radius;
    }
    if (other is ProcessedSmoothRadius) {
      return other.radius == radius;
    }

    return false;
  }

  @override
  int get hashCode => radius.hashCode;

  @override
  String toString() {
    return 'ProcessedSmoothRadius('
        'radius: $radius,'
        'a: ${a.toStringAsFixed(2)},'
        'b: ${b.toStringAsFixed(2)},'
        'c: ${c.toStringAsFixed(2)},'
        'd: ${d.toStringAsFixed(2)},'
        'p: ${p.toStringAsFixed(2)},'
        'width: ${width.toStringAsFixed(2)},'
        'height: ${height.toStringAsFixed(2)},'
        ')';
  }
}

extension PathSmoothCornersExtensions on Path {
  void addSmoothTopRight(ProcessedSmoothRadius radius, Rect rect) {
    final width = rect.width;
    final height = rect.height;
    if (radius.radius.cornerRadius > 0) {
      final a = radius.a;
      final b = radius.b;
      final c = radius.c;
      final d = radius.d;
      final p = radius.p;
      this
        ..moveTo(
          math.max(width / 2, width - p),
          0,
        )
        ..cubicTo(
          width - (p - a),
          0,
          width - (p - a - b),
          0,
          width - (p - a - b - c),
          d,
        )
        ..relativeArcToPoint(
          Offset(
            radius.circularSectionLength,
            radius.circularSectionLength,
          ),
          radius: radius.radius,
        )
        ..cubicTo(
          width,
          p - a - b,
          width,
          p - a,
          width,
          math.min(height / 2, p),
        );
      ;
    } else {
      this
        ..moveTo(width / 2, 0)
        ..lineTo(width, 0)
        ..lineTo(width, height / 2);
    }
  }

  void addSmoothBottomRight(ProcessedSmoothRadius radius, Rect rect) {
    final width = rect.width;
    final height = rect.height;
    if (radius.radius.cornerRadius > 0) {
      final a = radius.a;
      final b = radius.b;
      final c = radius.c;
      final d = radius.d;
      final p = radius.p;
      this
        ..moveTo(
          width,
          math.max(height / 2, height - p),
        )
        ..cubicTo(
          width,
          height - (p - a),
          width,
          height - (p - a - b),
          width - d,
          height - (p - a - b - c),
        )
        ..relativeArcToPoint(
          Offset(
            -radius.circularSectionLength,
            radius.circularSectionLength,
          ),
          radius: radius.radius,
        )
        ..cubicTo(
          width - (p - a - b),
          height,
          width - (p - a),
          height,
          math.max(width / 2, width - p),
          height,
        );
      ;
    } else {
      this
        ..lineTo(width, height)
        ..lineTo(width / 2, height);
    }
  }

  void addSmoothBottomLeft(ProcessedSmoothRadius radius, Rect rect) {
    final width = rect.width;
    final height = rect.height;
    if (radius.radius.cornerRadius > 0) {
      final a = radius.a;
      final b = radius.b;
      final c = radius.c;
      final d = radius.d;
      final p = radius.p;
      this
        ..moveTo(
          math.min(width / 2, p),
          height,
        )
        ..cubicTo(
          p - a,
          height,
          p - a - b,
          height,
          p - a - b - c,
          height - d,
        )
        ..relativeArcToPoint(
          Offset(
            -radius.circularSectionLength,
            -radius.circularSectionLength,
          ),
          radius: radius.radius,
        )
        ..cubicTo(
          0,
          height - (p - a - b),
          0,
          height - (p - a),
          0,
          math.max(height / 2, height - p),
        );
    } else {
      this
        ..lineTo(0, height)
        ..lineTo(0, height / 2);
    }
  }

  void addSmoothTopLeft(ProcessedSmoothRadius radius, Rect rect) {
    final width = rect.width;
    final height = rect.height;
    if (radius.radius.cornerRadius > 0) {
      final a = radius.a;
      final b = radius.b;
      final c = radius.c;
      final d = radius.d;
      final p = radius.p;
      this
        ..moveTo(
          0,
          math.min(height / 2, p),
        )
        ..cubicTo(
          0,
          p - a,
          0,
          p - a - b,
          d,
          p - a - b - c,
        )
        ..relativeArcToPoint(
          Offset(
            radius.circularSectionLength,
            -radius.circularSectionLength,
          ),
          radius: radius.radius,
        )
        ..cubicTo(
          p - a - b,
          0,
          p - a,
          0,
          math.min(width / 2, p),
          0,
        );
    } else {
      this
        ..lineTo(0, 0)
        ..close();
    }
  }
}
