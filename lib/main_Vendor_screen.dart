import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'views/screens/nav_screens/earning_screen.dart';
import 'views/screens/nav_screens/orders_screen.dart';
import 'views/screens/nav_screens/upload_screen.dart';
import 'views/screens/nav_screens/vendor_profile_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const VendorProfileScreen(),
    const UploadScreen(),
    const EditScreen(),
    const OrderScreen(),
    const VendorProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.pink,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.money_dollar), label: 'Earngins'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.upload_circle), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.shopping_cart), label: 'orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
