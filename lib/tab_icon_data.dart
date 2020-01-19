import 'package:flutter/material.dart';

class TabIconData {

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  AnimationController animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/home.png',
      selectedImagePath: 'assets/home_s.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/list.png',
      selectedImagePath: 'assets/list_s.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/gear.png',
      selectedImagePath: 'assets/gear_s.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/user.png',
      selectedImagePath: 'assets/user_s.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
