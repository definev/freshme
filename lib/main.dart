import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:freshme/image_frame.dart';
import 'package:freshme/menu_bar.dart';
import 'package:freshme/search_box.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Color(0xFFfac70d),
        textTheme: GoogleFonts.beVietnamProTextTheme(),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectMenu = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: SizedBox(
              child: SearchBox(),
              width: 300,
            ),
          ),
          Gap(30),
          ImageFrame(),
          Gap(30),
          ImageFrame(),
          Gap(30),
          MenuBar(
            onSelected: (value) => setState(() {
              selectMenu = value;
            }),
            selected: selectMenu,
            items: [
              MenuItem(Icon(CommunityMaterialIcons.hand), 'Donations'),
              MenuItem(Icon(CommunityMaterialIcons.newspaper_variant), 'Hub'),
              MenuItem(Icon(CommunityMaterialIcons.mailbox), 'Message'),
              MenuItem(Icon(CommunityMaterialIcons.information), 'Info'),
            ],
          ),
        ],
      ),
    );
  }
}
