import 'package:flutter/material.dart';

class MyFormHeader extends StatelessWidget {
  MyFormHeader({
    Key? key,
    required this.pLabel,
    this.textStyle,
  }) : super(key: key);

  final String pLabel;
  TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Theme.of(context).accentColor))),
            child: Text(
              pLabel,
              textAlign: TextAlign.left,
              style: textStyle ?? Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Theme.of(context).accentColor),
            ),
          ),
        ),
      ],
    );
  }
}
