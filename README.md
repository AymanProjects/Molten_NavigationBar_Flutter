# molten_navigationbar_flutter

An animated bottom navigation bar with a lot of attributes to teak and have fun with ✔🚀

| ![Image](example1.gif?raw=true) | ![Image](example2.gif?raw=true) | ![Image](example3.gif?raw=true) |
| :------------: | :------------: | :------------: |


## Getting Started

### Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  molten_navigationbar_flutter: ^1.0.0
```

### Import the package

```dart
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
```

## How to Use

You can use it in the scaffold's bottomnavigationbar, or anywhere you would like!
Just call the `MoltenBottomNavigationBar` widget and provide the `tabs`, `onTabChange` and `selectedIndex` attributes.
The rest of the attributes are optional

```
Scaffold(
   bottomNavigationBar: MoltenBottomNavigationBar(
      selectedIndex: _selectedIndex,
      onTabChange: (clickedIndex) {
        setState(() {
          _selectedIndex = clickedIndex;
        });
      },
      tabs: [
        MoltenTab(
          icon: Icon(Icons.search),
        ),
        MoltenTab(
          icon: Icon(Icons.home),
        ),
        MoltenTab(
          icon: Icon(Icons.person),
        ),
      ],
   ),
),
```

## `MoltenBottonNavigationBar`'s Attributes

| Attribute     | Type          | Description   |
| ------------- | ------------- | ------------- |
| barHeight     | double        | specify a Height for the bar, Default is kBottomNavigationBarHeight  |
| domeHeight     | double        | specify a Height for the Dome above tabs, Default is 15.0  |
| domeWidth     | double        | If domeWidth is null, it will be set to 100  |
| domeCircleColor     | Color        | If a null value is passed, the domeCircleColor will be Theme.primaryColor  |
| domeCircleSize     | double        | The size of the inner circle representing a seleted tab. Note that domeCircleSize must be less than or equal to (barHeight + domeHeight)  |
| margin     | EdgeInsets        | Spacing around the bar  |
| barColor     | Color        | specify a color to be used as a background color, Default is Theme.bottomAppBarColor  |
| tabs     | List<MoltenTab>        | List of MoltenTab, each wil have an icon as the main widget, selcted color and unselected color  |
| selectedIndex     | int        | The currently selected tab  |
| onTabChange     | Function(int index)        | callback function that will be triggered whenever a [MoltenTab] is clicked, and will return it's index.  |
| curve     | Curve        | Select a Curve value for the dome animation. Default is Curves.linear  |
| duration     | Duration        | How long the animation should last, Default is Duration(milliseconds: 150)  |
| borderSize     | double        | Applied to all 4 border sides, Default is 0  |
| borderColor     | Color        | Applied to all border sides  |
| borderRaduis     | BorderRadius        | How much each angle is curved. Note that high raduis values may decrease the dome width. |

## `MoltenTab`'s Attributes

| Attribute     | Type          | Description   |
| ------------- | ------------- | ------------- |
| icon     | double        | can be any widget, preferably an icon  |
| selectedColor     | double        | The icon color when the tab is selected, White if not set  |
| unselectedColor     | double        | The icon color when the tab is not selected, Grey if not set  |

### Example

You can find an example [here](https://github.com/AymanProjects/Molten_NavigationBar_Flutter/blob/master/example/lib/main.dart)



