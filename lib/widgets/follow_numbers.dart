import 'package:flutter/material.dart';

import '../../models/user.dart';

class FollowNumbers extends StatelessWidget {
  final User user;

  FollowNumbers({super.key, required this.user});

  Expanded followingContainer(
      ThemeData theme, String number, String text, GestureTapCallback? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 80,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style:
                    theme.textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style:
                    theme.textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(30, 30, 30, 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          followingContainer(
            theme,
            user.followersCount.toString(),
            'Followers',
            () async {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => UserListScreen(
              //             getUsers: user!.getFollowers,
              //             functionParams: const {},
              //           )),
              // );
            },
          ),
          const VerticalDivider(
            thickness: 1,
            color: Color.fromRGBO(45, 45, 45, 1.0),
          ),
          followingContainer(
            theme,
            user.followingsCount.toString(),
            'Followings',
            () async {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => UserListScreen(
              //             getUsers: user!.getFollowings,
              //             functionParams: const {},
              //           )),
              // );
            },
          ),
        ],
      ),
    );
  }
}
