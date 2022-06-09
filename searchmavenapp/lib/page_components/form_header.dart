import 'package:flutter/material.dart';

class MyFormHeader extends StatelessWidget {
  const MyFormHeader({
    Key? key,
    required this.pLabel,
  }) : super(key: key);

  final String pLabel;

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
              style: Theme.of(context)
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
