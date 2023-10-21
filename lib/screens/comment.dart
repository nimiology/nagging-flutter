import 'package:flutter/material.dart';

import '../models/nag.dart';
import '../widgets/appbar.dart';
import '../widgets/infinite_scroll.dart';
import 'nag.dart';
import '../widgets/nag.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/comment-screen';

  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final GlobalKey<InfiniteScrollScreenState> _refreshKey =
      GlobalKey<InfiniteScrollScreenState>();

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments ?? {};
    final route = routeArgs as Map;
    final nag = route['nag'] as NagModel;

    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.of(context)
                .pushNamed(NagScreen.routeName, arguments: {"replyId": nag.id});
            if (result == true) {
              _refreshKey.currentState?.onRefresh();
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            elevation: 8,
            padding: const EdgeInsets.all(16),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: SafeArea(
        child: InfiniteScrollScreen(
          key: _refreshKey,
          getNags: NagModel.getNags,
          functionParams: {#reply: nag.id.toString()},
          children: [
            CustomAppBar(
              title: nag.content,
              back: true,
              divider: true,
            ),
            NagWidget(nag:nag),
            const Divider(thickness: 2,),
          ],
        ),
      ),
    );
  }
}
