import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freshme/donation/donation_page.dart';
import 'package:freshme/fresh_widget/menu_bar.dart';

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
            child: Navigator(
              initialRoute: '/',
              onGenerateRoute: (route) {
                return MaterialPageRoute(
                  builder: (_) => const DonationPage(),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MenuBar(
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
        ],
      ),
    );
  }
}
