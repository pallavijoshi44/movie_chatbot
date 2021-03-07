import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15.0),
      child: Image.asset('assets/icon/app_icon.png', width: 30, height: 30, fit: BoxFit.cover,),
    );
  }
}
