library smart_searchable_dropdown;

import 'dart:convert';

import 'package:flutter/material.dart';


class SmartSearchableDropdown extends StatefulWidget {
  List items = [];
  String keyValue; // The key to display in the dropdown list
  List? initialValue;
  double? elementHeight; // Single variable for height
  Color? primaryColor;
  Color? backgroundColor;
  Color? dropdownBackgroundColor;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? menuPadding;
  EdgeInsetsGeometry? contentPadding;
  String? label;
  String? dropdownHintText;
  TextStyle? labelStyle;
  TextStyle? dropdownItemStyle;
  String? hint = '';
  String? multiSelectTag;
  int? initialIndex;
  Widget? prefixIcon;
  Widget? suffixIcon;
  bool? hideSearch;
  bool? enabled;
  bool? showClearButton;
  bool? menuMode;
  double? menuHeight;
  bool? multiSelect;
  bool? multiSelectValuesAsWidget;
  bool? showLabelInMenu;
  bool? showSelectedCount; // Show selected count
  bool? showSelectedList; // Show selected list
  String? itemOnDialogueBox;
  Decoration? decoration;
  final TextAlign? labelAlign;
  final ValueChanged onChanged;
  double? borderRadius;
  Color? borderColor;
  double? borderWidth;

  SmartSearchableDropdown({
    required this.items,
    required this.keyValue, // The key in the items to show in the dropdown list
    required this.onChanged,
    this.hint,
    this.initialValue,
    this.labelAlign,
    this.elementHeight, // Single variable for height
    this.primaryColor,
    this.padding,
    this.menuPadding,
    this.labelStyle,
    this.enabled,
    this.showClearButton,
    this.itemOnDialogueBox,
    this.prefixIcon,
    this.suffixIcon,
    this.menuMode = true,
    this.menuHeight,
    this.initialIndex,
    this.multiSelect,
    this.multiSelectTag,
    this.multiSelectValuesAsWidget,
    this.hideSearch,
    this.decoration,
    this.showLabelInMenu,
    this.dropdownItemStyle,
    this.backgroundColor,
    this.dropdownBackgroundColor,
    this.dropdownHintText,
    this.showSelectedCount, // New feature to show the count of selected items
    this.showSelectedList = true, // New feature to show the list of selected items
    this.label,
    this.contentPadding,
    this.borderRadius,
    this.borderColor,
    this.borderWidth
  });

  @override
  _SmartSearchableDropdownState createState() =>
      _SmartSearchableDropdownState();
}

class _SmartSearchableDropdownState extends State<SmartSearchableDropdown>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  String onSelectLabel = '';
  final searchC = TextEditingController();
  List menuData = [];
  List mainDataListGroup = [];
  List newDataList = [];
  List selectedValues = [];
  late AnimationController _menuController;

  @override
  void initState() {
    super.initState();
    setState(() {
      newDataList.clear();
      mainDataListGroup.clear();
      if (widget.items.isNotEmpty) {
        for (int i = 0; i < widget.items.length; i++) {
          menuData.add(widget.items[i][widget.keyValue].toString()); // Display based on `keyValue`
        }
        mainDataListGroup = menuData;
        newDataList = mainDataListGroup;
      }
      _menuController = AnimationController(
        duration:   const Duration(milliseconds: 300),
        vsync: this,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: widget.decoration,
              child: SizedBox(
                  height: widget.elementHeight, // Custom height for button
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
                      padding: widget.padding ?? const EdgeInsets.all(10),
                      elevation: 0, // Remove shadow/bottom line
                      shadowColor: Colors.transparent, // Remove shadow color
                      shape: RoundedRectangleBorder( // Apply border radius correctly
                        borderRadius:  BorderRadius.circular(widget.borderRadius??15),
                        side: BorderSide(
                          color:widget.borderColor?? Colors.blue, // Set the border color
                          width: widget.borderWidth?? 1.0, // Set the border width
                        ),// Your desired border radius
                      ),
                    ),
                    onPressed: widget.enabled == null || widget.enabled == true
                        ? () {
                      menuData.clear();
                      if (widget.items.isNotEmpty) {
                        for (int i = 0; i < widget.items.length; i++) {
                          menuData.add(widget.items[i][widget.keyValue].toString()); // Display based on `keyValue`
                        }
                        mainDataListGroup = menuData;
                        newDataList = mainDataListGroup;
                        searchC.clear();
                        if (widget.menuMode ?? true) {
                          if (_menuController.value != 1) {
                            _menuController.forward();
                          } else {
                            _menuController.reverse();
                          }
                        } else {
                          showDialogueBox(context,setState); // Show dialog if menuMode is false
                        }
                      }
                    }
                        : null,
                    child: Row(
                      children: [
                        widget.prefixIcon ?? const SizedBox(),
                        Expanded(
                          child: _buildSelectedDisplay(), // Build display based on bools
                        ),
                        widget.suffixIcon ??
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                      ],
                    ),
                  )
              ),
            ),
            if ((widget.menuMode ?? false )   && !(widget.hideSearch ?? false ) ) // Only show fixed search box if menuMode is true
              SizeTransition(
                sizeFactor: _menuController,
                child:   Container(
                    decoration: widget.decoration,
                    child: searchBox(setState)),
              ),
          ],
        ),
        if (widget.menuMode ?? false) // Show menu content if menuMode is true
          Visibility(
            visible: widget.menuMode ?? false,
            child: _showMenuMode(),
          ),
      ],
    );
  }

  Widget _buildSelectedDisplay() {

    if (widget.multiSelect ?? false) {
      if ((widget.showSelectedCount ?? false) &&
          (widget.showSelectedList ?? false)) {
        // Show both count and list
        return Text(
          '${selectedValues.length} items selected: ${_selectedValuesAsString().join(', ')}',
          style: widget.labelStyle ?? Theme.of(context).textTheme.bodyLarge,
        );
      } else if (widget.showSelectedCount ?? false) {
        // Show only count
        return Text(
          '${selectedValues.length} items selected',
          style: widget.labelStyle ?? Theme.of(context).textTheme.bodyLarge,
        );
      } else if (widget.showSelectedList ?? false) {
        // Show only list
        return Text(
          _selectedValuesAsString().isEmpty
              ? (widget.label ?? 'Select Value')
              : _selectedValuesAsString().join(', '),
          style: widget.labelStyle ?? Theme.of(context).textTheme.bodyLarge,
        );
      }
    }

    // Default behavior if not multiSelect or no display options are true
    return Text(
      onSelectLabel.isEmpty ? widget.label ?? 'Select Value' : onSelectLabel,
      style: widget.labelStyle ?? Theme.of(context).textTheme.bodyLarge,
      textAlign: widget.labelAlign ?? TextAlign.start,
    );
  }

  List _selectedValuesAsString() {
    return selectedValues.map((value) => value.toString()).toList();
  }

  Widget _showMenuMode() {
    return SizeTransition(
      sizeFactor: _menuController,
      child: mainScreen(setState),
    );
  }

  Future<void> showDialogueBox(BuildContext context,_setState) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Padding(
          padding: widget.menuPadding ?? const EdgeInsets.all(10),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  color: widget.dropdownBackgroundColor ?? Colors.white,
                  child: Padding(
                    padding: widget.menuPadding ?? const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Fit content size
                      children: [
                        // Search box (only shown in dialog when menuMode is false)
                        searchBox(setState),
                        Visibility(
                          visible: widget.multiSelect ?? false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: const Text('Select All'),
                                onPressed: () {
                                  setState(() {
                                    selectedValues = List.from(newDataList);
                                  });
                                },
                              ),
                              TextButton(
                                child: const Text('Clear All'),
                                onPressed: () {
                                  setState(() {
                                    selectedValues.clear();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        // Main list (make sure it updates with search results)
                        Expanded(
                          child: mainList(setState),
                        ),
                        // "Select All", "Clear All" and buttons at the bottom
                        // Close and Done buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Visibility(
                              visible: widget.multiSelect ?? false,
                              child: TextButton(
                                child: const Text('Done'),
                                onPressed: () {
                                  setState((){


                                    var sendList = [];
                                    for (int i = 0; i < menuData.length; i++) {
                                      if (selectedValues
                                          .contains(menuData[i])) {
                                        sendList.add(widget.items[i]);
                                      }
                                    }
                                    widget.onChanged(jsonEncode(sendList));
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
    _setState(() {

    });
  }

  Widget searchBox(Function setState) {
    return Visibility(
      visible: widget.hideSearch == null ? true : !widget.hideSearch!,
      child: Material(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: widget.elementHeight ?? 50.0, // Set height via widget.elementHeight or default to 50.0
            child: TextFormField(
              controller: searchC,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                contentPadding: widget.contentPadding?? const EdgeInsets.all(10),
                suffixIcon: Icon(Icons.search, color: widget.primaryColor),
                hintText: widget.dropdownHintText ?? 'Search here...',
                border: OutlineInputBorder( // Defines the default border
                  borderRadius: BorderRadius.circular(widget.borderRadius??  15), // Same border radius as button
                  borderSide: BorderSide(
                    color:widget.borderColor?? Colors.grey, // Default border color
                    width:widget.borderWidth?? 1.0, // Default border width
                  ),
                ),
                enabledBorder: OutlineInputBorder( // Border when text field is enabled
                  borderRadius: BorderRadius.circular(widget.borderRadius??  15), // Same border radius as button
                  borderSide: BorderSide(
                    color:widget.borderColor?? Colors.grey, // Default border color
                    width:widget.borderWidth?? 1.0, // Border width when not focused
                  ),
                ),
                focusedBorder: OutlineInputBorder( // Border when text field is focused
                  borderRadius: BorderRadius.circular(widget.borderRadius??  15), // Same border radius as button
                  borderSide: BorderSide(
                    color:widget.borderColor?? Colors.blue, // Border color when focused
                    width:widget.borderWidth?? 1.0, // Thicker border when focused
                  ),
                ),
              ),
              textAlign: TextAlign.start, // Center the text in the field
              onChanged: (v) {
                // Update the state inside the dialog
                onItemChanged(v, setState);
              },
            ),
          )

      ),
    );
  }

  Widget mainScreen(setState) {
    return Padding(
      padding: widget.menuPadding ?? const EdgeInsets.all(0),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(12),
        color: widget.dropdownBackgroundColor ??
            Theme.of(context).colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: (widget.showLabelInMenu ?? false) && widget.label != null,
              child: Padding(
                padding:   const EdgeInsets.all(8.0),
                child: Text(
                  widget.label.toString(),
                  style: widget.labelStyle ??
                      Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        color: widget.primaryColor ?? Colors.blue,
                      ),
                ),
              ),
            ),
            Visibility(
              visible: widget.multiSelect ?? false,
              child: Row(
                children: [
                  TextButton(
                    child: const Text('Select All'),
                    onPressed: () {
                      setState(() {
                        selectedValues = List.from(newDataList);
                      });
                    },
                  ),
                  TextButton(
                    child: const Text('Clear All'),
                    onPressed: () {
                      setState(() {
                        selectedValues.clear();
                      });
                    },
                  ),
                ],
              ),
            ),
            widget.menuMode ?? false
                ? SizedBox(
              height: widget.menuHeight ?? 150,
              child: mainList(setState),
            )
                : Expanded(
              child: mainList(setState),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    if (widget.menuMode ?? false) {
                      _menuController.reverse();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Visibility(
                  visible: widget.multiSelect ?? false,
                  child: TextButton(
                    child: const Text('Done'),
                    onPressed: () {
                      var sendList = [];
                      for (int i = 0; i < menuData.length; i++) {
                        if (selectedValues.contains(menuData[i])) {
                          sendList.add(widget.items[i]);
                        }
                      }
                      widget.onChanged(jsonEncode(sendList));
                      if (widget.menuMode ?? false) {
                        _menuController.reverse();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget mainList(setState) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: newDataList.length,
        itemBuilder: (BuildContext context, int index) {
          var item = newDataList[index]; // item is a map

          return ListTile(
            leading: widget.multiSelect ?? false
                ? Checkbox(
              value: selectedValues.contains(item),
              onChanged: (bool? value) {
                if (value != null && value) {
                  setState(() {
                    selectedValues.add(item);
                  });
                } else {
                  setState(() {
                    selectedValues.remove(item);
                  });
                }
              },
            )
                : null,
            title: Text(item.toString(), // Display the value from the map using widget.keyValue
              style: widget.dropdownItemStyle ??
                  Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              if(!(widget.multiSelect??false)){
                setState(() {
                  // Use the specific key's value as the selected label
                  onSelectLabel = item.toString();

                  // Pass the entire item (map) to the onChanged callback
                  widget.onChanged(jsonEncode(widget.items[index]));

                  if (widget.menuMode ?? false) {
                    _menuController.reverse();
                  } else {
                    Navigator.pop(context);
                  }
                });
              }else{

                if (!selectedValues.contains(item)) {
                  setState(() {
                    selectedValues.add(item);
                  });
                } else {
                  setState(() {
                    selectedValues.remove(item);
                  });
                }
              }
            },
          );
        },
      ),
    );
  }



  void onItemChanged(String value, Function setState) {
    setState(() {
      newDataList = mainDataListGroup
          .where((string) =>
          string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
}
