import 'package:flutter/material.dart';

class CentreTextWidget extends StatelessWidget {
  const CentreTextWidget(
    String msg, {
    super.key,
  });

  String get msg => this.msg;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(msg));
  }
}
