import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:sig_schedule_test/screens/library.dart';

class CustomBottomNavagationBar extends StatefulWidget {
  const CustomBottomNavagationBar({Key? key, required this.setBottomIndex}) : super(key: key);
  final Function setBottomIndex;

  @override
  State<CustomBottomNavagationBar> createState() => _CustomBottomNavagationBarState();
}

class _CustomBottomNavagationBarState extends State<CustomBottomNavagationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.setBottomIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDeleteBadgesCount(),
        builder: (context, snapshot) {
          return BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.done),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                  label: 'Delete',
                  icon: badges.Badge(
                    badgeContent: Text(
                      snapshot.data.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900
                      ),
                    ),
                    child: Icon(Icons.delete),
                  ),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          );
      }
    );
  }
}
