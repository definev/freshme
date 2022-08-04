import 'package:animations/animations.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freshme/donation/page/donation_page.dart';
import 'package:freshme/_internal/presentation/fresh_widget/fresh_menu_bar.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectMenu = useState(0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: PageTransitionSwitcher(
              transitionBuilder: (child, animation, secondaryAnimation) =>
                  SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              ),
              child: const DonationPage(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: FreshMenuBar(
                onSelected: (value) => selectMenu.value = value,
                selected: selectMenu.value,
                items: const [
                  MenuItem(Icon(CommunityMaterialIcons.hand), 'Donations'),
                  MenuItem(
                      Icon(CommunityMaterialIcons.newspaper_variant), 'Hub'),
                  MenuItem(Icon(CommunityMaterialIcons.mailbox), 'Message'),
                  MenuItem(Icon(CommunityMaterialIcons.information), 'Info'),
                ],
              ),
            ),
          ),
          const _DonationSheet(),
        ],
      ),
    );
  }
}

class _DonationSheet extends HookWidget {
  const _DonationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final topOffset = useState(200.0);

    return Positioned(
      right: 0,
      left: 0,
      top: topOffset.value,
      height: 100,
      child: SnappingSheet.horizontal(
        lockOverflowDrag: true,
        snappingPositions: const [
          SnappingPosition.factor(
            positionFactor: 1.0,
            grabbingContentOffset: GrabbingContentOffset.bottom,
          ),
          SnappingPosition.factor(
            positionFactor: 0.5,
          ),
          SnappingPosition.factor(
            positionFactor: 0.2,
          ),
        ],
        grabbingWidth: 50,
        grabbing: GestureDetector(
          onPanUpdate: (details) =>
              topOffset.value = topOffset.value + details.delta.dy,
          child: _GrabbingWidget(),
        ),
        sheetRight: SnappingSheetContent(
          draggable: true,
          childScrollController: scrollController,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(15),
              scrollDirection: Axis.horizontal,
              children: const [
                NumberBox(number: "1"),
                NumberBox(number: "2"),
                NumberBox(number: "3"),
                NumberBox(number: "4"),
                NumberBox(number: "5"),
                NumberBox(number: "6"),
                NumberBox(number: "7"),
                NumberBox(number: "8"),
                NumberBox(number: "9"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GrabbingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15),
            width: 7,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
          Container(
            width: 2,
            color: Colors.grey[300],
            margin: const EdgeInsets.only(top: 15, bottom: 15),
          )
        ],
      ),
    );
  }
}

class NumberBox extends StatelessWidget {
  final String number;

  const NumberBox({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 75,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.lightGreen[300],
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Center(child: Text(number)),
    );
  }
}
