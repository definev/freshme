
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:freshme/_internal/presentation/fresh_carousel.dart';
import 'package:markdown/markdown.dart' as md;

class CarouselBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final urls = parseUrl(element.attributes['images']!);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: FreshCarousel(imageUrls: urls),
    );
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
