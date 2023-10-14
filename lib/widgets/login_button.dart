import 'package:flutter/material.dart';

import 'circular_progress_indicator.dart';

class LoginButton extends StatefulWidget {
  final String title;
  final bool loading;
  final GestureTapCallback function;

  const LoginButton(
      {Key? key,
      required this.loading,
      required this.function,
      required this.title})
      : super(key: key);

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.function,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(10, 106, 255, 1),
                Color.fromRGBO(111, 211, 255, 1),
              ],
            )),
        child: SizedBox(
          height: 50,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: widget.loading
                  ? const SizedBox(
                      height: 30,
                      width: 30,
                      child:
                          CustomCircularProgressIndicator(color: Colors.white))
                  : Text(widget.title, style: theme.textTheme.headlineLarge),
            ),
          ),
        ),
      ),
    );
  }
}
