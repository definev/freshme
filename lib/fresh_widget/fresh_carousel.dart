import 'dart:math' as math;
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:indexed/indexed.dart';

enum _ScrollState { left, right, none }

class FreshCarousel extends StatefulWidget {
  const FreshCarousel({
    super.key,
    required this.imageUrls,
  });

  final List<String> imageUrls;

  @override
  State<FreshCarousel> createState() => _FreshCarouselState();
}

class _FreshCarouselState extends State<FreshCarousel>
    with SingleTickerProviderStateMixin {
  Size _constraints = Size.zero;

  int _currentIndex = 0;
  int? get _potentialIndex {
    switch (_scrollState) {
      case _ScrollState.left:
        return _currentIndex == widget.imageUrls.length - 1
            ? 0
            : _currentIndex + 1;
      case _ScrollState.right:
        return _currentIndex == 0
            ? widget.imageUrls.length - 1
            : _currentIndex - 1;

      case _ScrollState.none:
        return null;
    }
  }

  final double _threshold = 800;

  double _startPoint = 0;
  double _updatePoint = 0;

  Animatable<double> _lerpPointAnimatable = Tween(begin: 0, end: 0);
  double get _lerpPoint => _lerpPointAnimatable.evaluate(_controller);
  set _lerpPoint(double value) {
    _lerpPointAnimatable = Tween(begin: value, end: value);
  }

  double get haftLerpPoint => _lerpPoint > 0.5 ? 1 : _lerpPoint / 0.5;
  double get mirrorLerpPoint =>
      _lerpPoint > 0.5 ? (1 - _lerpPoint) / 0.5 : _lerpPoint / 0.5;
  double get left {
    double left = 0;

    switch (_scrollState) {
      case _ScrollState.left:
        left = -mirrorLerpPoint * _constraints.width;
        break;
      default:
        left = mirrorLerpPoint * _constraints.width;
        break;
    }

    return left;
  }

  static const _angle = [
    -.6,
    -.5,
    -.4,
    .4,
    .55,
    .6,
  ];
  late final _rotateAngle = () {
    math.Random rand = math.Random();

    return _angle[rand.nextInt(_angle.length)] * 0.1;
  }();
  final _scale = 1.01;

  bool _disablePan = false;
  _ScrollState _scrollState = _ScrollState.none;

  late final AnimationController _controller = () {
    AnimationController controller = AnimationController(
      vsync: this,
      duration: 800.ms,
    );

    controller.addStatusListener((status) {
      if (status != AnimationStatus.completed) {
        _disablePan = true;

        setState(() {});

        return;
      }

      if (_lerpPoint == 1) {
        _currentIndex = _potentialIndex ?? _currentIndex;
      }
      _lerpPointAnimatable = Tween(begin: 0, end: 0);
      _scrollState = _ScrollState.none;
      _disablePan = false;
      setState(() {});
    });

    controller.addListener(() => setState(() {}));

    return controller;
  }();

  void _updatePosition(double startPoint, double updatePoint) {
    if (updatePoint > startPoint) {
      _lerpPoint = math.min((updatePoint - startPoint) / _threshold, 1);
    } else {
      _lerpPoint = math.min((startPoint - updatePoint) / _threshold, 1);
    }

    setState(() {});
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('lerpPoint', _lerpPoint));
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (_updatePoint == _startPoint && _scrollState == _ScrollState.none) {
      _updatePoint = details.localPosition.dx;
      if (_updatePoint > _startPoint) {
        _scrollState = _ScrollState.right;
      }
      if (_updatePoint < _startPoint) {
        _scrollState = _ScrollState.left;
      }
    }

    _updatePoint = details.localPosition.dx;
    switch (_scrollState) {
      case _ScrollState.left:
        if (_updatePoint > _startPoint) {
          _updatePoint = _startPoint;
        }
        break;
      case _ScrollState.right:
        if (_updatePoint < _startPoint) {
          _updatePoint = _startPoint;
        }
        break;
      default:
    }

    _updatePosition(_startPoint, _updatePoint);
  }

  void onPanEnd(DragEndDetails details) {
    _controller.value = 0;
    if (_lerpPoint > 0.2 || details.velocity.pixelsPerSecond.dx.abs() > 1000) {
      _controller.duration = 800.ms * (1 - _lerpPoint);
      _lerpPointAnimatable = Tween<double>(begin: _lerpPoint, end: 1)
          .chain(CurveTween(curve: Curves.ease));
    } else {
      _controller.duration = 200.ms;
      _lerpPointAnimatable = Tween<double>(begin: _lerpPoint, end: 0)
          .chain(CurveTween(curve: Curves.ease));
    }
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              ignoring: _disablePan,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _constraints = constraints.biggest;

                  final indexer = Indexer(
                    clipBehavior: Clip.none,
                    children: [
                      Indexed(
                        index: _lerpPoint > 0.5 ? 1 : 0,
                        child: Positioned(
                          top: 0,
                          bottom: 0,
                          left: -left,
                          width: _constraints.width,
                          child: Transform.rotate(
                            angle: lerpDouble(_rotateAngle, 0, _lerpPoint)!,
                            child: Transform.scale(
                              scale: lerpDouble(_scale, 1, _lerpPoint)!,
                              child: ColoredBox(
                                color: Color.lerp(
                                  const Color(0xFFfac70d),
                                  Colors.white,
                                  haftLerpPoint,
                                )!,
                                child: DottedBorder(
                                  strokeWidth:
                                      2 * lerpDouble(1, _scale, _lerpPoint)!,
                                  borderType: BorderType.Rect,
                                  padding: EdgeInsets.zero,
                                  dashPattern: [
                                    3,
                                    lerpDouble(0, 5, haftLerpPoint)!
                                  ],
                                  strokeCap: StrokeCap.round,
                                  child: Padding(
                                    padding: _scrollState == _ScrollState.none
                                        ? EdgeInsets.zero
                                        : const EdgeInsets.all(6),
                                    child: _potentialIndex == null
                                        ? const SizedBox()
                                        : Image.network(
                                            widget.imageUrls[_potentialIndex!],
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Indexed(
                        index: _lerpPoint > 0.5 ? 0 : 1,
                        child: Positioned(
                          top: 0,
                          bottom: 0,
                          left: left,
                          width: _constraints.width,
                          child: Transform.rotate(
                            angle: lerpDouble(0, _rotateAngle, _lerpPoint)!,
                            child: Transform.scale(
                              scale: lerpDouble(1, _scale, _lerpPoint)!,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      color: Color.lerp(
                                        Colors.white,
                                        const Color(0xFFfac70d),
                                        haftLerpPoint,
                                      )!,
                                      padding: const EdgeInsets.all(6),
                                      child: Opacity(
                                        opacity:
                                            lerpDouble(1, 0, haftLerpPoint)!,
                                        child: Image.network(
                                          widget.imageUrls[_currentIndex],
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: DottedBorder(
                                      strokeWidth: 2 *
                                          lerpDouble(1, _scale, _lerpPoint)!,
                                      borderType: BorderType.Rect,
                                      padding: EdgeInsets.zero,
                                      dashPattern: [
                                        3,
                                        lerpDouble(5, 0, haftLerpPoint)!
                                      ],
                                      strokeCap: StrokeCap.round,
                                      child: const SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );

                  if (widget.imageUrls.length <= 1) return indexer;
                  return GestureDetector(
                    onPanStart: (details) {
                      _startPoint = details.localPosition.dx;
                      _updatePoint = details.localPosition.dx;
                    },
                    onPanUpdate: onPanUpdate,
                    onPanEnd: onPanEnd,
                    child: indexer,
                  );
                },
              ),
            ),
          ),
          if (widget.imageUrls.length > 1)
            Align(
              alignment: Alignment.bottomCenter,
              widthFactor: 1.0,
              child: _CarouselIndicator(
                widget: widget,
                potentialIndex: _potentialIndex,
                currentIndex: _currentIndex,
                lerpPoint: _lerpPoint,
              ),
            ),
        ],
      ),
    );
  }
}

class _CarouselIndicator extends StatelessWidget {
  const _CarouselIndicator({
    Key? key,
    required this.widget,
    required int? potentialIndex,
    required int currentIndex,
    required double lerpPoint,
  })  : _potentialIndex = potentialIndex,
        _currentIndex = currentIndex,
        _lerpPoint = lerpPoint,
        super(key: key);

  final FreshCarousel widget;
  final int? _potentialIndex;
  final int _currentIndex;
  final double _lerpPoint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SeparatedRow(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        separatorBuilder: () => const Gap(4),
        children: [
          for (int index = 0; index < widget.imageUrls.length; index++)
            SizedBox(
              height: 20,
              child: Align(
                alignment: Alignment.center,
                widthFactor: 1.0,
                child: SizedBox(
                  height: 12,
                  width: _potentialIndex == null
                      ? index == _currentIndex
                          ? 24
                          : 12
                      : lerpDouble(
                          24,
                          12,
                          index == _currentIndex
                              ? _lerpPoint
                              : index == _potentialIndex
                                  ? 1 - _lerpPoint
                                  : 1,
                        ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _potentialIndex == null
                          ? index == _currentIndex
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent
                          : Color.lerp(
                              Theme.of(context).colorScheme.primary,
                              Colors.transparent,
                              index == _currentIndex
                                  ? _lerpPoint
                                  : index == _potentialIndex
                                      ? 1 - _lerpPoint
                                      : 1,
                            ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
