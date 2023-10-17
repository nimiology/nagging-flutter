import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NaggingAppBar extends StatelessWidget {
  const NaggingAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child:
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Nagging',
              style: GoogleFonts.playfairDisplay(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

    );
  }
}
