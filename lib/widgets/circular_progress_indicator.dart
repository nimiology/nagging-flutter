import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color color;
  const CustomCircularProgressIndicator({Key? key ,  this.color=Colors.grey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(strokeWidth: 3, color: color);
  }
}
