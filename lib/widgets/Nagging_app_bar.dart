import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/profile.dart';

class NaggingAppBar extends StatelessWidget {
  const NaggingAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Nagging',
            style: GoogleFonts.playfairDisplay(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(
                  context, ProfileScreen.routeName,arguments: {});
            },
            child: SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                'assets/svg/user.svg',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
