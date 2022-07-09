import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FreshTabBar extends StatefulWidget {
  const FreshTabBar({
    Key? key,
    required this.items,
    required this.controller,
  }) : super(key: key);

  final List<TabItem> items;
  final TabController controller;

  @override
  State<FreshTabBar> createState() => _FreshTabBarState();
}

class _FreshTabBarState extends State<FreshTabBar> {
  int selected = 0;

  void onTabChanged() {
    selected = widget.controller.index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onTabChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
      child: SizedBox(
        height: 48,
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(4, 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFfac70d),
                    border: Border.all(width: 2),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SeparatedRow(
                      separatorBuilder: () => const VerticalDivider(
                        width: 2,
                        thickness: 2,
                        color: Colors.black,
                      ),
                      children: [
                        for (int i = 0; i < widget.items.length; i += 1)
                          SizedBox(
                            width: (constraints.biggest.width - 4) / 3,
                            child: ElevatedButton(
                              style: getElevatedStyle(i),
                              onPressed: () => widget.controller.animateTo(
                                i,
                                curve: Curves.easeInBack,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                widthFactor: 1.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    widget.items[i].icon,
                                    const Gap(10),
                                    Text(
                                      widget.items[i].title,
                                      style: const TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final activeButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: const Color(0xFF127681),
    minimumSize: const Size(0, 48),
    shape: const RoundedRectangleBorder(),
    padding: const EdgeInsets.all(0),
    surfaceTintColor: Colors.white,
  );
  final deactiveButtonStyle = TextButton.styleFrom(
    minimumSize: const Size(0, 48), disabledForegroundColor: const Color(0xFF127681).withOpacity(0.38),
    shape: const RoundedRectangleBorder(),
    padding: const EdgeInsets.all(0),
    surfaceTintColor: Colors.white,
  );

  ButtonStyle getElevatedStyle(int i) {
    return selected == i ? activeButtonStyle : deactiveButtonStyle;
  }
}

class TabItem {
  const TabItem(this.icon, this.title);

  final Widget icon;
  final String title;
}
