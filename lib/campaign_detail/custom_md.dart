import 'dart:collection';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

enum _ScrollState { up, down, none }

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
  final _angle = [
    -.6,
    -.5,
    -.4,
    .4,
    .55,
    .6,
  ];

  Size _constraints = Size.zero;

  int _currentIndex = 0;

  double get _threshold => _constraints.width / 2;

  double _startPoint = 0;
  double _updatePoint = 0;

  double lerpPoint = 0;
  double left = 0;

  final _rotateAngle = -0.04;
  final _scale = 1.01;

  bool _disablePan = false;
  _ScrollState _scrollState = _ScrollState.none;

  late final AnimationController _controller = () {
    AnimationController controller = AnimationController(
      vsync: this,
      duration: 300.ms,
    );

    controller.addStatusListener((status) {
      if (status != AnimationStatus.completed) {
        _disablePan = true;
        setState(() {});
        return;
      }

      _disablePan = false;
      setState(() {});
    });

    return controller;
  }();

  void _updatePosition(double startPoint, double updatePoint) {
    if (updatePoint > startPoint) {
      lerpPoint = math.min((updatePoint - startPoint) / _threshold, 1);
    } else {
      lerpPoint = math.min((startPoint - updatePoint) / _threshold, 1);
    }
    var distance = (updatePoint - startPoint) / _threshold;

    if (distance < 0) {
      distance = math.max(-1, distance);
      if (distance <= -0.5) {
        left = (-1 - distance) / 0.5 * _constraints.width;
      } else {
        left = distance / 0.5 * _constraints.width;
      }
    } else {
      distance = math.min(1, distance);
      if (distance >= 0.5) {
        left = (1 - distance) / 0.5 * _constraints.width;
      } else {
        left = distance / 0.5 * _constraints.width;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.4,
          child: IgnorePointer(
            ignoring: _disablePan,
            child: LayoutBuilder(
              builder: (context, constraints) {
                _constraints = constraints.biggest;
                return GestureDetector(
                  onPanStart: (details) {
                    _controller.value = 0;
                    _startPoint = details.localPosition.dx;
                    _updatePoint = details.localPosition.dx;
                  },
                  onPanUpdate: (details) {
                    if (_updatePoint == _startPoint &&
                        _scrollState == _ScrollState.none) {
                      _updatePoint = details.localPosition.dx;
                      if (_updatePoint > _startPoint) {
                        _scrollState = _ScrollState.up;
                      }
                      if (_updatePoint < _startPoint) {
                        _scrollState = _ScrollState.down;
                      }
                    }

                    _updatePoint = details.localPosition.dx;
                    switch (_scrollState) {
                      case _ScrollState.down:
                        if (_updatePoint > _startPoint) {
                          _updatePoint = _startPoint;
                        }
                        break;
                      case _ScrollState.up:
                        if (_updatePoint < _startPoint) {
                          _updatePoint = _startPoint;
                        }
                        break;
                      default:
                    }

                    _updatePosition(_startPoint, _updatePoint);
                  },
                  onPanEnd: (_) {
                    _scrollState = _ScrollState.none;
                    setState(() {});
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: -left,
                        width: _constraints.width,
                        child: Transform.rotate(
                          angle: lerpDouble(_rotateAngle, 0, lerpPoint)!,
                          child: Transform.scale(
                            scale: lerpDouble(_scale, 1, lerpPoint)!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFfac70d),
                                border: Border.all(width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: left,
                        width: _constraints.width,
                        child: Transform.rotate(
                          angle: lerpDouble(0, _rotateAngle, lerpPoint)!,
                          child: Transform.scale(
                            scale: lerpDouble(1, _scale, lerpPoint)!,
                            child: DottedBorder(
                              strokeWidth: 2,
                              borderType: BorderType.RRect,
                              dashPattern: const [3, 3, 1],
                              strokeCap: StrokeCap.round,
                              radius: const Radius.circular(2),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Image.network(
                                  widget.imageUrls[_currentIndex],
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Slider(
          value: lerpPoint,
          onChanged: (value) => setState(() => lerpPoint = value),
        )
      ],
    );
  }
}

class CarouselBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final urls = parseUrl(element.attributes['images']!);

    return FreshCarousel(imageUrls: urls);
  }

  List<String> parseUrl(String textContent) =>
      textContent.substring(13, textContent.length - 1).split(',');
}

class CarouselSyntax extends md.BlockSyntax {
  @override
  md.Node? parse(md.BlockParser parser) {
    final crs = md.Element(
      'crs',
      [
        md.Text(''),
      ],
    );
    crs.attributes['images'] = parser.current;
    final md.Element el = md.Element('p', [crs]);

    parseChildLines(parser);

    return el;
  }

  @override
  RegExp get pattern => RegExp(r'^(\[\[carousel\]\])\((.*)\)$');
}
