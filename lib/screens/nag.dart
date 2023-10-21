import 'package:flutter/material.dart';
import 'package:nagging/widgets/circular_progress_indicator.dart';

import '../models/nag.dart';
import '../widgets/appbar.dart';

class NagScreen extends StatefulWidget {
  static const routeName = '/nag-screen';

  NagScreen({super.key});

  @override
  State<NagScreen> createState() => _NagScreenState();
}

class _NagScreenState extends State<NagScreen> {
  final nagController = TextEditingController();

  bool nagging = false;

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments ?? {};
    final route = routeArgs as Map;
    final replyId = route['replyId'];

    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            if (!nagging && nagController.text.isNotEmpty) {
              nagging = true;
              setState(() {});
              final nagContent = nagController.text;
              final requestStatusCode = await NagModel.nag(nagContent, replyId);
              nagging = false;
              if (requestStatusCode == 201) {
                Navigator.of(context).pop(true);
              } else {
                print(requestStatusCode);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("something went wrong"),
                ));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            elevation: 8,
            padding: const EdgeInsets.all(16),
          ),
          child: !nagging
              ? const Icon(
                  Icons.add,
                  color: Colors.white,
                )
              : const CustomCircularProgressIndicator()),
      body: SafeArea(
        child: ListView(
          children: [
            const CustomAppBar(
              back: true,
              title: 'Nag',
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: nagController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 221,
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
