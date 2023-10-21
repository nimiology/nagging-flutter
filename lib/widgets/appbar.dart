import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget {
  final bool back;
  final bool divider;
  final String title;

  const CustomAppBar(
      {Key? key,
      this.back = false,
      this.divider = true,
      this.title = 'Hallery'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: divider ? 10 : 20),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              if (back)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: SvgPicture.asset(
                      'assets/svg/chevron-left.svg',
                      width: 16,
                      height: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(width: 10,),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (divider) const Divider(thickness: 1,)
      ],
    );
  }
}
