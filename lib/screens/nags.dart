import 'package:flutter/material.dart';

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
    return Scaffold(
        body: InfiniteScrollScreen(
      getNags: () {},
      children: [],
    ));
  }
}
