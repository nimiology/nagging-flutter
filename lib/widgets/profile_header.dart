import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../helper/string_extension.dart';
import '../../models/user.dart';
import '../screens/settings.dart';
import 'appbar.dart';
import 'follow_numbers.dart';
import 'profile_icon_grid.dart';

class ProfileHeader extends StatefulWidget {
  User user;
  final bool back;
  final bool isCurrentUser;

  ProfileHeader(
      {Key? key,
      required this.user,
      required this.back,
      required this.isCurrentUser})
      : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool fullBio = false;
  bool following = false;

  void follow() async {
    if (!following) {
      following = true;
      widget.user.following = !widget.user.following;
      setState(() {});
      widget.user.following = !widget.user.following;
      widget.user.following = await widget.user.follow();
      setState(() {});
      following = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      if (widget.back)
        const CustomAppBar(
          back: true,
          divider: false,
          title: '',
        ),
      Text(
        widget.user.id.toString(),
        style: GoogleFonts.lato(
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      FollowNumbers(user: widget.user),
      Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.8,
            shrinkWrap: true,
            children: [
              if (widget.user.location != null &&
                  widget.user.location!.isNotEmpty)
                ProfileIconGrid(
                  title: widget.user.location!,
                  icon: 'location-dot.svg',
                ),
              if (widget.user.link != null && widget.user.link!.isNotEmpty)
                ProfileIconGrid(
                  title: widget.user.link!,
                  icon: 'link.svg',
                  link: widget.user.link!,
                ),
              ProfileIconGrid(
                title:
                    DateFormat('E MMM dd yyyy').format(widget.user.dateJoined!),
                icon: 'calendar.svg',
              ),
              widget.isCurrentUser
                  ? GestureDetector(
                      onTap: () async {
                        widget.user = await Navigator.pushNamed(
                            context, SettingScreen.routeName,
                            arguments: {'user': widget.user}) as User;
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        padding: const EdgeInsets.all(10),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.settings, color: Colors.black),
                      ),
                    )
                  : GestureDetector(
                      onTap: follow,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        padding: const EdgeInsets.all(10),
                        height: 50,
                        decoration: BoxDecoration(
                          color: (widget.user.following)
                              ? Colors.blue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          (widget.user.following)
                              ? Icons.person_remove
                              : Icons.person_add,
                          color: (widget.user.following)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ))
            ]),
      ),
      if (widget.user.bio != null)
        GestureDetector(
          onTap: () {
            fullBio = !fullBio;
            setState(() {});
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            width: 350,
            child: Text(widget.user.bio!.addSpacesToFirstParagraph(),
                maxLines: fullBio ? null : 4,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    overflow: fullBio ? null : TextOverflow.ellipsis)),
          ),
        ),
    ]);
  }
}
