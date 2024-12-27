import 'package:ak_golden_project/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../screens/dashboard_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/bill_details.dart';
import '../screens/profile_screen.dart';

class BottomNavigationScreens extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  BottomNavigationScreens({super.key}) {
    Get.put(_controller);
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      const DashboardScreen(),
      OrderHistoryScreen(),
      const BillDetails(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.brown,
        inactiveColorPrimary: Colors.grey,
        iconSize: 24.0, // Adjust icon size as needed
        contentPadding: 0,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.message_outlined),
        title: ("New Order"),
        activeColorPrimary: Colors.brown,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.history),
        title: ("History"),
        activeColorPrimary: Colors.brown,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.shopping_cart_outlined),
        title: ("Cart"),
        activeColorPrimary: Colors.brown,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: ("Account"),
        activeColorPrimary: Colors.brown,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller.index != 0) {
          _controller.jumpToTab(0);
          return false;
        }
        return true;
      },
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        navBarStyle: NavBarStyle.style3
      ),
    );
  }
}
