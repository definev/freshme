import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

class FreshMenuBar extends HookWidget {
  const FreshMenuBar({
    Key? key,
    required this.selected,
    required this.items,
    required this.onSelected,
  }) : super(key: key);

  final int selected;
  final List<MenuItem> items;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RepaintBoundary(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 2),
            color: const Color(0xFF127681),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: const Color(0xFF127681).withOpacity(0.2),
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRect(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 64,
                minHeight: 64,
                maxWidth: 400,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SeparatedRow(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    separatorBuilder: () => const Gap(8),
                    children: [
                      for (int item = 0; item < items.length; item += 1)
                        MenuItemButton(
                          show: item == selected,
                          item: items[item],
                          onPressed: () => onSelected(item),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem(this.icon, this.title);

  final Widget icon;
  final String title;
}

class MenuItemButton extends StatelessWidget {
  const MenuItemButton({
    Key? key,
    required this.show,
    required this.item,
    required this.onPressed,
  }) : super(key: key);

  final bool show;
  final MenuItem item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: show
          ? ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: const Color(0xFFfac70d),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(width: show ? 2 : 0),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              elevation: 0,
              shadowColor: Colors.white,
            )
          : TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              disabledForegroundColor: Colors.white.withOpacity(0.38).withOpacity(0.38),
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              backgroundColor: const Color(0xFFfac70d).withOpacity(0.0),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              elevation: 0,
            ),
      onPressed: onPressed,
      child: AnimatedSize(
        duration: 300.ms,
        curve: Curves.ease,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            TweenAnimationBuilder<Color?>(
                duration: 300.ms,
                curve: Curves.decelerate,
                tween: ColorTween(
                  begin: const Color(0xFF127681),
                  end: show ? Colors.black : Colors.white,
                ),
                builder: (context, value, child) {
                  return IconTheme(
                    data: IconThemeData(size: 23, color: value),
                    child: item.icon,
                  );
                }),
            if (show) ...[
              const Gap(10),
              Text(
                item.title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
