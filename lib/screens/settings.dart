import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user.dart';
import '../widgets/circular_progress_indicator.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/setting-screen';

  SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  String bio = '';
  String location = '';
  String link = '';

  bool uploading = false;

  late User user;

  Widget textField(
      TextEditingController controller, String hintText, bool multilines) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        keyboardType: multilines ? TextInputType.multiline : TextInputType.text,
        maxLength: multilines ? 150 : 50,
        maxLines: multilines ? null : 1,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    user = routeArgs['user'];

    bioController.text = user.bio ?? bio;
    linkController.text = user.link ?? link;
    locationController.text = user.location ?? location;

    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, user);
                      },
                      child: const Icon(
                        Icons.keyboard_backspace_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'Setting',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        uploading = true;
                        bio = bioController.text;
                        link = linkController.text;
                        location = locationController.text;
                        setState(() {});
                        if (!uploading) {
                          final User? updatedUser = await user.updateUser(
                              bioParameters: bio,
                              // linkParameters: link,
                              locationParameters: location);
                          if (updatedUser != null) {
                            Navigator.pop(context, updatedUser);
                          } else {
                            uploading = false;
                            setState(() {});
                          }
                        }
                      },
                      child: uploading
                          ? const CustomCircularProgressIndicator()
                          : const Icon(
                              Icons.done,
                              color: Colors.grey,
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
          textField(bioController, 'Bio', true),
          textField(locationController, 'Location', false),
          // textField(linkController, 'Link', false),
        ],
      ),
    ));
  }
}
