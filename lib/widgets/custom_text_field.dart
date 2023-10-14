import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String svg;
  final TextEditingController controller;
  final bool obscureText;
  final bool? enabled;
  final bool error;

  CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.svg,
      this.obscureText = false,
      this.enabled,
      this.error = false})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final focusNode = FocusNode();
  bool hasFocus = false;

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: hasFocus ? LinearGradient(
          colors: widget.error
              ? [
                  const Color.fromRGBO(211, 46, 46, 1),
                  const Color.fromRGBO(255, 94, 94, 1),
                ]
              : [
                  const Color.fromRGBO(10, 106, 255, 1),
                  const Color.fromRGBO(111, 211, 255, 1),
                ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ): null,
        border: Border.all(),
        color: hasFocus? null: const Color.fromRGBO(50, 50, 50, 1),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 0, 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: widget.controller,
                enabled: widget.enabled,
                style: theme.textTheme.bodyLarge,
                obscureText: widget.obscureText,
                focusNode: focusNode,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color.fromRGBO(120, 120, 120, 1)),
                    counterStyle: theme.textTheme.bodyLarge),
              ),
            ),
            SvgPicture.asset(
              'assets/svg/${widget.svg}',
              width: 24,
              height: 24,
              color: const Color.fromRGBO(120, 120, 120, 1),
            )
          ],
        ),
      ),
    );
  }
}
