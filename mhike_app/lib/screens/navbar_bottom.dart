import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mhike_app/screens/home/hike_list_screen.dart';
import 'package:mhike_app/screens/map/map_screen.dart';
import 'package:mhike_app/screens/setting/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavBarBottom extends StatefulWidget {
  const NavBarBottom({super.key});

  @override
  State<NavBarBottom> createState() => _NavBarBottomState();
}

class _NavBarBottomState extends State<NavBarBottom> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      decoration: const NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: Offset(0, 2),
          ),
        ],
        colorBehindNavBar: Colors.transparent,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style10,
      navBarHeight: 65,
      confineInSafeArea: true,
      context,
      screens: [
        HikeListScreen(),
        MapScreen(),
        ProfileScreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.group_solid),
          title: 'Home',
          textStyle: const TextStyle(fontSize: 14),
          activeColorPrimary: CupertinoColors.systemCyan,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          activeColorSecondary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.location_solid),
          title: 'Map',
          textStyle: const TextStyle(fontSize: 14),
          activeColorPrimary: CupertinoColors.systemGreen,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          activeColorSecondary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: 'Profile',
          textStyle: const TextStyle(fontSize: 14),
          activeColorPrimary: CupertinoColors.systemPurple,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          activeColorSecondary: CupertinoColors.white,
        ),
      ],
    );
  }
}
