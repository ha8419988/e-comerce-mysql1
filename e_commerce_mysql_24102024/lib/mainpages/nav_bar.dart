import 'package:e_commerce_riverpod_and_backend/mainpages/home_page.dart';
import 'package:e_commerce_riverpod_and_backend/mainpages/profile.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;
  final List<Widget> listPages = [
    const HomePage(),
    const Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: listPages[currentIndex],
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
              backgroundColor: Colors.black,
              icon: Icons.home,
              extras: {'label': 'Home'}),
          FluidNavBarIcon(
              backgroundColor: Colors.black,
              icon: Icons.person,
              extras: {'label': 'Profile'}),
        ],
        onChange: (selectedIndex) {
          setState(() {
            currentIndex = selectedIndex;
          });
        },
        style: const FluidNavBarStyle(
            iconSelectedForegroundColor: Colors.white,
            iconUnselectedForegroundColor: Colors.white,
            barBackgroundColor: Color.fromARGB(255, 148, 195, 234)),
        defaultIndex: 0,
        scaleFactor: 1.5,
      ),
    );
  }
}
