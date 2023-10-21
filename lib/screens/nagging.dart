import 'package:flutter/material.dart';

import '../models/nag.dart';
import '../widgets/Nagging_app_bar.dart';
import '../widgets/infinite_scroll.dart';
import 'nag.dart';

class NaggingScreen extends StatefulWidget {
  static const routeName = '/nagging-screen';

  const NaggingScreen({super.key});

  @override
  State<NaggingScreen> createState() => _NaggingScreenState();
}

class _NaggingScreenState extends State<NaggingScreen> {
  final GlobalKey<InfiniteScrollScreenState> _refreshKey = GlobalKey<InfiniteScrollScreenState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(NagScreen.routeName);
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
        body: InfiniteScrollScreen(
          key: _refreshKey,
          getNags: Nag.getNags,
          children: const [
            NaggingAppBar(),
          ],
        ));
  }
}
