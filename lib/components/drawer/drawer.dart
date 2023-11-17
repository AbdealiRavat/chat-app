import 'package:flutter/material.dart';

import '../../utlis/colors.dart';
import '../cards/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final Function()? signOut;
  final Function()? openProfile;
  final Function()? openHome;
  const MyDrawer({
    super.key,
    required this.signOut,
    required this.openProfile,
    required this.openHome,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: purple_secondary,
      // selectedIndex: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                  //
                  // duration: Duration(milliseconds: 800),
                  // curve: Curves.fastOutSlowIn,
                  child: Icon(
                Icons.person_rounded,
                size: 80,
                color: Colors.white,
              )),
              MyListTile(text: 'H O M E', icon: Icons.home, onTap: openHome),
              MyListTile(
                  text: 'U S E R', icon: Icons.person, onTap: openProfile),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: MyListTile(
                text: 'L O G O U T', icon: Icons.logout, onTap: signOut),
          ),
        ],
      ),
    );
  }
}
