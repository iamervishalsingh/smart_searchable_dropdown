 
# SmartSearchableDropdown

A highly customizable dropdown widget for Flutter that supports searching, single-select, and multi-select options.

## Features
- Customizable dropdown design (border, colors, padding).
- Supports both single and multi-select modes.
- Search functionality for easy filtering of items.
- Dynamic and adjustable UI properties like height, padding, and label styling.
- Display selected items count, list of selected items, or custom label.

 
## List

```javascript
List ItemList = [
                {'id': 1, 'name': 'Vishal'},
                {'id': 2, 'name': 'Pragya'},
                {'id': 3, 'name': 'Chotu'},
                {'id': 7, 'name': 'CU'},
                {'id': 4, 'name': 'Pari'},
              ],
 

```
## Preview

<img src="https://github.com/iamervishalsingh/smart_searchable_dropdown/blob/main/assets/1.gif" alt="SmartSearchableDropdown Demo" width="250" height="400">
 
 

## 1. Menu mode with signle selection
```javascript 
 SmartSearchableDropdown(
              items: ItemList,
              onChanged: (value) {
                print('Selected Value: '+value.toString());
              },
              label: 'Select Name',  
              hideSearch: true ,
              menuHeight: 200,
              menuMode: true, 
              borderRadius: 0, 
              keyValue: 'name',
            ),
```

<img src="https://github.com/iamervishalsingh/smart_searchable_dropdown/blob/main/assets/3.gif" alt="SmartSearchableDropdown Demo" width="250" height="400"> 
 

## 2. Menu mode with multi selection
```javascript 
 SmartSearchableDropdown(
              items: ItemList,
              onChanged: (value) {
                print('Selected Value: '+value.toString());
              },
              multiSelect: true,
              label: 'Select Name',  
              hideSearch: true ,
              menuHeight: 200,
              menuMode: true, 
              borderRadius: 0, 
              keyValue: 'name',
            ),
```

<img src="https://github.com/iamervishalsingh/smart_searchable_dropdown/blob/main/assets/2.gif" alt="SmartSearchableDropdown Demo" width="250" height="400">  
 

## 3. Menu mode with Searchable selection
```javascript 
 SmartSearchableDropdown(
              items: ItemList,
              onChanged: (value) {
                print('Selected Value: '+value.toString());
              },
              multiSelect: true,
              label: 'Select Name',  
              hideSearch: false ,
              menuHeight: 200,
              menuMode: true, 
              borderRadius: 0, 
              keyValue: 'name',
            ),
```

<img src="https://github.com/iamervishalsingh/smart_searchable_dropdown/blob/main/assets/4.gif" alt="SmartSearchableDropdown Demo" width="250" height="400">  

## 4. Dialog Box mode selection
```javascript 
 SmartSearchableDropdown(
              items: ItemList,
              onChanged: (value) {
                print('Selected Value: '+value.toString());
              },
              multiSelect: true,
              label: 'Select Name',  
              hideSearch: false ,
              menuHeight: 200,
              menuMode: false,  // false this for dialogbox mode 
              showSelectedList: true,
              showLabelInMenu: true,
              showSelectedCount: true,
              borderRadius: 0, 
              keyValue: 'name',
            ),
```
*This is a preview of the SmartSearchableDropdown in action.*

## Installation

1. Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  smart_searchable_dropdown:
   
```

# Hi, I'm Vishal Singh! 👋

## Feedback

If you have any feedback, please reach out to us at iamervishalsingh@gmail.com#   s m a r t _ s e a r c h a b l e _ d r o p d o w n 
 
 # smart_searchable_dropdown
