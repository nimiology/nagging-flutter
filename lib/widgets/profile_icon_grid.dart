import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileIconGrid extends StatelessWidget {
  final String title;
  final String icon;
  final String? link;
  final double iconSize;

  const ProfileIconGrid({
    Key? key,
    required this.title,
    required this.icon,
    this.link,
    this.iconSize = 18,
  }) : super(key: key);

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(link!);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 30, 30, 1.0),
        borderRadius: BorderRadius.circular(15),
      ),
      height: 50,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/$icon',
            width: 18,
            height: 18,
            color: const Color.fromRGBO(255, 144, 108, 1.0),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: link != null
                ? GestureDetector(
                    onTap: _launchURL,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                : Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
