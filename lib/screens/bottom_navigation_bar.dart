import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
        future: _getDeleteBadgesCount(),
        builder: (context, snapshot) {
          return BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorite',
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

  Future<String> _getDeleteBadgesCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> jsonData = prefs.getStringList('data') ?? [];

    var ListArray = [];

    for (int i = 0; i < jsonData.length; i++) {
      if (jsonDecode(jsonData[i])['state'] == 'delete') {
        ListArray.add(jsonDecode(jsonData[i]));
      }
    }

    String count = ListArray.length.toString();

    return count;
  }
}
