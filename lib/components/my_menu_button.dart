import 'package:flutter/material.dart';

class MyMenuButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const MyMenuButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), 
          color: Colors.cyan),
          alignment: Alignment.center,
        child: Text(
          title, 
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}