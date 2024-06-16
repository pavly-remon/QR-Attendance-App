import 'package:flutter/material.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({Key? key}) : super(key: key);

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.green[800],
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }
}
