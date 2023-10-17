import 'package:flutter/material.dart';

import '../models/nag.dart';
import '../widgets/Nagging_app_bar.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/nag.dart';

class NagsScreen extends StatefulWidget {
  static const routeName = '/nags-screen';

  const NagsScreen({super.key});

  @override
  State<NagsScreen> createState() => _NagsScreenState();
}

class _NagsScreenState extends State<NagsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: InfiniteScrollScreen(
      getNags: Nag.getNags,
      children: [
        NaggingAppBar(),
      ],
    ));
  }
}
