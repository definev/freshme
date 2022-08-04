import 'package:flutter/material.dart';

class FreshSnackBar extends StatelessWidget {
  const FreshSnackBar({
    super.key,
    required this.title,
  });
  final Widget title;

  static SnackBar getSnackBar({
    required Widget title,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return SnackBar(
      content: FreshSnackBar(title: title),
      backgroundColor: Colors.transparent,
      padding: padding.add(const EdgeInsets.only(bottom: 4)),
      behavior: SnackBarBehavior.floating,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: SizedBox(
        height: 48,
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(3, 3),
                child: ColoredBox(
                  color: theme.colorScheme.secondary,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: theme.colorScheme.onError,
                  ),
                  color: theme.colorScheme.error,
                ),
                child: SizedBox.expand(
                  child: Center(
                    child: DefaultTextStyle(
                      style: theme //
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: theme.colorScheme.onError),
                      child: title,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
