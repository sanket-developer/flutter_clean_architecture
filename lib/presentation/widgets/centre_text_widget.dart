import 'package:flutter/material.dart';

class CentreTextWidget extends StatelessWidget {
  final String msg;

  const CentreTextWidget(
    this.msg, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(msg),
    );
  }
}