import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

class NagWidget extends StatelessWidget {
  final userLike = null;

  const NagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text(
              '1',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    (userLike != null)
                        ? 'assets/svg/solid-heart.svg'
                        : 'assets/svg/heart.svg',
                    width: 24,
                    height: 24,
                    color: (userLike != null) ? Colors.red : Colors.white,
                  )),
              GestureDetector(
                  onTap: () {
                    Share.share(
                        'check out this artwork https://twitterbutanonymous.pythonanywhere.com/tweet/${widget.painting!.id}',
                        subject: 'Check this artwork.');
                  },
                  child: SvgPicture.asset('assets/svg/share-nodes.svg',
                      width: 24, height: 24, color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }
}
