library molten_navigationbar_flutter;

import 'dart:ui';
import 'package:flutter/material.dart';

class MoltenBottomNavigationBar extends StatelessWidget {
  /// specify a Height for the bar, Default is expanded
  final double barHeight;

  /// specify a Height for the Dome above tabs, Default is 15.0
  final double domeHeight;

  /// If [domeWidth] is null, it will be set to 100
  final double domeWidth;

  /// If a null value is passed, the [domeCircleColor] will be Theme.primaryColor
  final Color domeCircleColor;

  /// The size of the inner circle represents a seleted tab
  ///
  /// Note that [domeCircleSize] must be less than or equal to (barHeight + domeHeight)
  final double domeCircleSize;

  /// Spacing around the bar, Default is [EdgeInsets.zero]
  final EdgeInsets margin;

  /// specify a color to be used as a background color, Default is Theme.bottomAppBarColor
  ///
  /// If the opacity is less than 1, it will automatically be 1
  final Color barColor;

  /// List of [MoltenTab], each wil have an icon as the main widget, selcted color and unselected color
  final List<MoltenTab> tabs;

  /// The currently selected tab
  final int selectedIndex;

  /// A callback function that will be triggered whenever a [MoltenTab] is clicked, and will return it's index.
  final Function(int index) onTabChange;

  /// Select a [Curve] value for the dome animation. Default is [Curves.linear]
  final Curve curve;

  /// How long the animation should last, Default is Duration(milliseconds: 150)
  final Duration duration;

  /// Applied to all 4 border sides, Default is 0
  final double borderSize;

  /// Applied to all border sides
  final Color borderColor;

  /// How much each angle is curved.
  /// Default is: (topLeft: Radius.circular(10), topRight: Radius.circular(10))
  ///
  /// Note that high raduis values may decrease the dome width.
  final BorderRadius borderRaduis;

  /// An animated bottom navigation that makes your app looks better
  /// with customizable attrinutes
  ///
  /// Give an [onTabChange] callback to specify what will happen whenever a tab is selected.
  /// [tabs] are of type MoltenTab, use them to display selectable tabs.
  MoltenBottomNavigationBar({
    Key key,
    this.barHeight = kBottomNavigationBarHeight,
    this.barColor,
    this.domeHeight = 15.0,
    this.domeWidth = 100,
    this.domeCircleColor,
    this.domeCircleSize = 50.0,
    this.tabs,
    this.margin = EdgeInsets.zero,
    @required this.selectedIndex,
    @required this.onTabChange,
    this.duration,
    this.curve = Curves.linear,
    this.borderColor,
    this.borderSize = 0,
    this.borderRaduis,
  })  : assert(tabs != null),
        assert(onTabChange != null),
        assert(selectedIndex != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final _borderRaduis = borderRaduis ??
          BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10));

      final Color _barColor =
          (barColor?.withOpacity(1)) ?? Theme.of(context).bottomAppBarColor;

      final Color _domeCircleColor =
          (domeCircleColor?.withOpacity(1)) ?? Theme.of(context).primaryColor;

      final double _tabWidth =
          (constraints.biggest.width - margin.horizontal) / tabs.length;

      final double _domeWidth =
          (domeWidth == null || domeWidth > _tabWidth) ? _tabWidth : domeWidth;

      assert(domeCircleSize <= (barHeight + domeHeight),
          'domeCircleSize must be less than or equal to (barHeight + domeHeight)');

      return Container(
        height: barHeight + domeHeight,
        margin: margin,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                color: _barColor,
                borderRadius: _borderRaduis,
                border: Border.all(
                  width: borderSize,
                  color: (borderColor == null || borderSize < 1)
                      ? _barColor
                      : borderColor,
                ),
              ),
            ),
            // border for the dome
            _animatedPositionedDome(
              top: 0,
              tabWidth: _tabWidth,
              domeWidth: _domeWidth - _borderRaduis.topRight.x,
              domeHeight: domeHeight,
              domeColor:
                  borderSize > 0 ? (borderColor ?? _barColor) : _barColor,
            ),
            // Actual dome
            _animatedPositionedDome(
              top: borderSize < 1 ? 1 : (borderSize + 0.2),
              tabWidth: _tabWidth,
              domeWidth: _domeWidth - borderSize - _borderRaduis.topRight.x,
              domeHeight: domeHeight,
              domeColor: _barColor,
            ),
            AnimatedPositioned(
              top: 0,
              bottom: 0,
              curve: curve,
              duration: duration ?? Duration(milliseconds: 150),
              left: _tabWidth * selectedIndex,
              width: _normalizeDomeOnEdge(_tabWidth, selectedIndex),
              child: Center(
                child: Container(
                  height: domeCircleSize,
                  decoration: BoxDecoration(
                    color: _domeCircleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            ...tabs.map((tab) {
              int index = tabs.indexOf(tab);
              return AnimatedPositioned(
                curve: curve,
                duration: duration ?? Duration(milliseconds: 150),
                top: index == selectedIndex ? 0 : domeHeight,
                bottom: 0,
                left: _tabWidth * index,
                width: _normalizeDomeOnEdge(_tabWidth, index),
                child: _MoltenTabWrapper(
                  tab: tab,
                  onTab: () => onTabChange(index),
                  isSelected: index == selectedIndex,
                  circleSize: domeCircleSize,
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _animatedPositionedDome({
    double top,
    double domeWidth,
    double domeHeight,
    Color domeColor,
    double tabWidth,
  }) {
    return AnimatedPositioned(
      curve: curve,
      duration: duration ?? Duration(milliseconds: 150),
      top: top,
      left: tabWidth * selectedIndex,
      child: AnimatedContainer(
        duration: duration ?? Duration(milliseconds: 150),
        width: _normalizeDomeOnEdge(tabWidth, selectedIndex),
        child: Center(
          child: _MoltenDome(
            color: domeColor,
            height: domeHeight,
            width: domeWidth,
          ),
        ),
      ),
    );
  }

  double _normalizeDomeOnEdge(double x, int index) {
    double newPos;
    if (index == 0)
      newPos = x + borderSize;
    else if (index == tabs.length - 1)
      newPos = x - borderSize;
    else
      newPos = x;

    return newPos;
  }
}

/// Wraps the [MoltenTab] with extra attributes.
class _MoltenTabWrapper extends StatelessWidget {
  final MoltenTab tab;
  final bool isSelected;
  final Function onTab;
  final double circleSize;
  _MoltenTabWrapper({
    this.tab,
    this.isSelected,
    this.onTab,
    this.circleSize,
  });
  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: isSelected
            ? tab.selectedColor ?? Colors.white
            : tab.unselectedColor ?? Colors.grey,
      ),
      child: Container(
        height: circleSize,
        width: circleSize,
        child: Material(
          shape: CircleBorder(
              side: BorderSide(width: 0, color: Colors.transparent)),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTab(),
            child: tab.icon,
          ),
        ),
      ),
    );
  }
}

class MoltenTab {
  /// Can be any [Widget].
  final Widget icon;

  /// The [icon] color when the tab is seleted
  ///
  /// White if not set
  final Color selectedColor;

  /// The [icon] color when the tab is unseleted.
  ///
  /// Grey if not set
  final Color unselectedColor;

  /// This represents each tab in the navigation bar.
  ///
  /// [icon] must not be null
  MoltenTab({
    @required this.icon,
    this.selectedColor,
    this.unselectedColor,
  }) : assert(icon != null);
}

class _MoltenDome extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  _MoltenDome({
    this.color,
    this.height,
    this.width,
  })  : assert(color != null),
        assert(height != null),
        assert(width != null);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _DomePainter(color: color),
          size: Size(width, height),
        );
      },
    );
  }
}

class _DomePainter extends CustomPainter {
  final Color color;
  _DomePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    Path path = Path();
    path.lineTo(0, size.height);
    path.cubicTo(
        0, size.height, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width * 0.94, size.height, size.width * 0.83,
        size.height * 0.65, size.width * 0.72, size.height * 0.31);
    path.cubicTo(size.width * 0.67, size.height * 0.12, size.width * 0.59,
        size.height * 0.01, size.width * 0.51, 0);
    path.cubicTo(
        size.width * 0.51, 0, size.width * 0.51, 0, size.width * 0.51, 0);
    path.cubicTo(size.width * 0.42, -0.01, size.width * 0.34,
        size.height * 0.11, size.width * 0.27, size.height * 0.31);
    path.cubicTo(size.width * 0.17, size.height * 0.65, size.width * 0.06,
        size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, size.height, 0, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
