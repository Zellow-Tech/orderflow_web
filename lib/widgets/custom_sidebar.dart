import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';

class OFGSideBar extends StatefulWidget {
  const OFGSideBar({super.key, required this.body});
  final Widget body;

  @override
  _OFGSideBarState createState() => _OFGSideBarState();
}

class _OFGSideBarState extends State<OFGSideBar> {
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CollapsibleSidebar(
          
          isCollapsed: isCollapsed,
          items: [
            CollapsibleItem(
                text: 'Dashboard', icon: Icons.dashboard, onPressed: () {}),
            CollapsibleItem(
                text: 'Orders', icon: Icons.shopping_cart, onPressed: () {}),
            CollapsibleItem(
                text: 'Profile', icon: Icons.person, onPressed: () {}),
          ],
          avatarImg: AssetImage('assets/avatar.jpg'),
          title: 'OrderFlow',
          backgroundColor: Colors.blueGrey.shade900,
          textStyle: TextStyle(color: Colors.white, fontSize: 16),
          selectedTextColor: Colors.blueAccent,
          selectedIconColor: Colors.blueAccent,
          body: widget.body, // Replace with your main content
        ),
        Positioned(
          top: 20,
          left: isCollapsed ? 80 : 250,
          child: IconButton(
            icon: Icon(isCollapsed ? Icons.menu : Icons.close,
                color: Colors.white),
            onPressed: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
          ),
        ),
      ],
    );
  }
}
