import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:smart_searchable_dropdown/smart_searchable_dropdown.dart'; // Import your package

void main() {
  runApp(SmartSearchableDropdownExampleApp());
}

class SmartSearchableDropdownExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List itemList= [
      {'id': 1, 'name': 'Vishal'},
      {'id': 2, 'name': 'Pragya'},
      {'id': 3, 'name': 'Chotu'},
      {'id': 7, 'name': 'CU'},
      {'id': 4, 'name': 'Pari'},
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('SmartSearchableDropdown Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:  SmartSearchableDropdown(
            items: itemList,
            keyValue: 'name',
            onChanged: (value) {
              print('Selected Value: '+value .toString());
            },
            label: 'Select Name',
            multiSelect: true,
            hideSearch: false ,
            menuHeight: 200,
            menuMode: true,
            showSelectedList: true,
            showLabelInMenu: true,
            borderRadius: 0,
          ),
        ),
      ),
    );
  }
}
