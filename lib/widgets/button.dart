import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final text;
  final onPressed;

  const Button({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.white,
        child: CupertinoButton(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          onPressed: this.onPressed,
          child: Container(
            height: 20,
            width: 60,
            child: Center(
              child: Text(
                this.text,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
