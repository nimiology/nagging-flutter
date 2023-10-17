import 'package:flutter/material.dart';

import 'profile_icon_grid.dart';

class ProfileInfo extends StatelessWidget {
  final String icon;
  final String text;
  final String? link;
  final double iconSize;

  const ProfileInfo({
    required this.icon,
    required this.text,
    this.link,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 3,
        shrinkWrap: true,
        children: [
          ProfileIconGrid(
            title: text,
            icon: icon,
            link: link,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }
}
