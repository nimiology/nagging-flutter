import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../models/nag.dart';
import '../screens/comment.dart';
import '../screens/profile.dart';

class NagWidget extends StatefulWidget {
  final NagModel nag;
  final bool commentActive;

  const NagWidget({super.key, required this.nag, this.commentActive=false});

  @override
  State<NagWidget> createState() => _NagWidgetState();
}

class _NagWidgetState extends State<NagWidget> {
  bool liking = false;

  void like() async {
    if (!liking) {
      liking = true;
      final userLike = widget.nag.userLike;
      setState(() {
        if (widget.nag.userLike != null) {
          widget.nag.userLike = null;
        } else {
          widget.nag.userLike = 0;
        }
      });
      widget.nag.userLike = userLike;
      widget.nag.userLike = await widget.nag.like();
      setState(() {});
      liking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName,
                  arguments: {"user": widget.nag.owner});
            },
            child: SizedBox(
              child: Text(
                widget.nag.owner.id.toString(),
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.nag.content,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: like,
                      child: SvgPicture.asset(
                        (widget.nag.userLike != null)
                            ? 'assets/svg/heart-solid.svg'
                            : 'assets/svg/heart.svg',
                        width: 24,
                        height: 24,
                        color: (widget.nag.userLike != null)
                            ? Colors.red
                            : Colors.white,
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  if (widget.nag.likesCount > 0)
                    Text(
                      '${widget.nag.likesCount} Likes',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )
                ],
              ),
              if(widget.commentActive)GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(CommentScreen.routeName, arguments: {"nag": widget.nag});
                  },
                  child: SvgPicture.asset('assets/svg/comment.svg',
                      width: 24, height: 24, color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }
}
