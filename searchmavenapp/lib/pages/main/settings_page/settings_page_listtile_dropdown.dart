import 'package:flutter/material.dart';

class MyListTileWithDropdown extends StatelessWidget {
  const MyListTileWithDropdown({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.dropdownChoices,
    required this.dropdownValue,
    required this.persistDropdownChoice,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final List dropdownChoices;
  final Object dropdownValue;
  final Function persistDropdownChoice;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      enabled: true,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton(
        items: dropdownChoices
            .map(
              (item) => DropdownMenuItem(
                child: Text("$item"),
                value: item,
              ),
            )
            .toList(),
        value: dropdownValue,
        onChanged: (item) {
          debugPrint("Changing $title to: $item");
          persistDropdownChoice(item);
        },
      ),
    );
  }
}
