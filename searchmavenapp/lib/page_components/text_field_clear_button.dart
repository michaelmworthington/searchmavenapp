import 'package:flutter/material.dart';

class MyTextFieldClearButton extends StatelessWidget {
  final Function() onPressed;

  final double size = 30.0;

  const MyTextFieldClearButton({Key? key, required this.onPressed})
      : super(key: key);

  // NOTE: This was mostly unnecessary. I could have just put the Icon directly in the text box
  //       This widget adds a circle styling around the icon
  //       https://fluttertutorial.in/textformfield-clear-and-set-text-value-in-flutter/
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: const Alignment(0.0, 0.0), // all centered
            children: <Widget>[
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).dialogBackgroundColor,
                ),
              ),
              Icon(
                Icons.clear,
                size: size * 0.6, // 60% width for icon
                color: Theme.of(context).hintColor,
              )
            ],
          ),
        ),
      );
}
