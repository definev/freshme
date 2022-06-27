import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

class MenuBar extends HookWidget {
  const MenuBar({
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
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 2),
            color: Color(0xFF127681),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Color(0xFF127681).withOpacity(0.2),
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 48,
              minHeight: 48,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(width: show ? 2 : 0),
              ),
              primary: Color(0xFFfac70d),
              onPrimary: Colors.white,
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
              elevation: 0,
              shadowColor: Colors.white,
            )
          : TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              primary: Colors.white,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Color(0xFFfac70d).withOpacity(0.0),
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                  begin: Color(0xFF127681),
                  end: show ? Colors.black : Colors.white,
                ),
                builder: (context, value, child) {
                  return IconTheme(
                    data: IconThemeData(size: 23, color: value),
                    child: item.icon,
                  );
                }),
            if (show) ...[
              Gap(10),
              Text(
                item.title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
