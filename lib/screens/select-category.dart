import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class SelectCategoryWidget extends StatefulWidget {
  SelectCategoryWidget();

  @override
  State<SelectCategoryWidget> createState() => _SelectCategoryWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  String dropdownValue = 'Shirts';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 100,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
          dropdownColor: Colors.blue,
          value: dropdownValue,
          icon: const Icon(
            Icons.arrow_downward,
            color: Colors.white,
          ),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.white),
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['Shirts', 'Pants', 'Hats', 'Jackets', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
