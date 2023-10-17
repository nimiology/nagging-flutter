import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../models/nag.dart';

class NagWidget extends StatelessWidget {
  final Nag nag;

  const NagWidget({super.key, required this.nag});

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
              nag.owner.id.toString(),
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            nag.content,
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
                    (nag.userLike != null)
                        ? 'assets/svg/solid-heart.svg'
                        : 'assets/svg/heart.svg',
                    width: 24,
                    height: 24,
                    color: (nag.userLike != null) ? Colors.red : Colors.white,
                  )),
              GestureDetector(
                  onTap: () {
                    Share.share(
                        'check out this artwork https://twitterbutanonymous.pythonanywhere.com/tweet/${nag.id}',
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
