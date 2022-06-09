import 'package:flutter/material.dart';

class ArtifactFieldTextEllipsis extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final String value;
  final TextStyle? valueStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const ArtifactFieldTextEllipsis({
    Key? key,
    required this.label,
    this.labelStyle,
    required this.value,
    this.valueStyle,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextOverflow? myOverflow;

    if (overflow == null && maxLines != null) {
      myOverflow = TextOverflow.ellipsis;
    } else {
      myOverflow = overflow ?? TextOverflow.visible;
    }

    // I like this better since it wraps the value in the whole column
    return RichText(
      maxLines: maxLines,
      overflow: myOverflow,
      // softWrap: true,
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: labelStyle ?? Theme.of(context).textTheme.labelLarge,
          ),
          TextSpan(
            text: ":  ",
            style: labelStyle ?? Theme.of(context).textTheme.labelLarge,
          ),
          TextSpan(
            text: value.replaceAll(
                '', '\u{200B}'), //hack so it doesn't automatically wrap
            style: valueStyle ?? Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );

    // return Text(
    //   '$pLabel: ${pValue?.replaceAll('', '\u{200B}')}', //good for now: workaround for ellipsis - replace each with tiny-space unicode - https://github.com/flutter/flutter/issues/18761
    //   style: pStyle,
    //   maxLines: 5,
    //   overflow:
    //       TextOverflow.ellipsis, //see workaround: this truncates long lines
    //   // overflow: TextOverflow.fade,
    //   // softWrap: false,
    // );

    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       label,
    //       style: Theme.of(context).textTheme.labelLarge,
    //     ),
    //     const SizedBox(
    //       width: 8,
    //     ),
    //     Expanded(
    //       child: Text('$value'),
    //     )
    //   ],
    // );
  }
}
