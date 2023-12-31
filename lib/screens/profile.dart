import 'package:flutter/material.dart';

import '../models/nag.dart';
import '../models/user.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile-screen';

  late User user;
  late Map<Symbol, dynamic> map;
  bool isCurrentUser = false;

  ProfileScreen({Key? key}) : super(key: key);

  Future<void> loadData(BuildContext context) async {
    final routeArgs = ModalRoute.of(context)!.settings.arguments ?? {};
    final route = routeArgs as Map;

    if (route['user'] != null) {
      user = await route['user'].minimalToAllFields();
    } else {
      isCurrentUser = true;
      user = await User.me();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<void>(
        future: loadData(context),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CustomCircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return const Center(child: CustomCircularProgressIndicator());
              } else {
                return InfiniteScrollScreen(
                  functionParams: {
                    #owner: user.id.toString(),
                    #ordering: '-created_date',
                  },
                  getNags: NagModel.getNags,
                  children: [
                    ProfileHeader(
                        user: user,
                        back: !isCurrentUser,
                        isCurrentUser: isCurrentUser),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                );
              }
          }
        },
      )),
    );
  }
}
