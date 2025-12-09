import 'package:flutter/material.dart';

class WFlex extends StatelessWidget {
  const WFlex._({
    this.mainAxisAlignment = .start,
    this.mainAxisSize = .max,
    this.crossAxisAlignment = .center,
    this.textDirection = .ltr,
    this.verticalDirection = .down,
    this.textBaseline = .alphabetic,
    this.direction = .horizontal,
    this.divider,
    this.children = const [],
  });

  factory WFlex.row({
    MainAxisAlignment mainAxisAlignment = .start,
    MainAxisSize mainAxisSize = .max,
    CrossAxisAlignment crossAxisAlignment = .center,
    TextDirection textDirection = .ltr,
    VerticalDirection verticalDirection = .down,
    TextBaseline textBaseline = .alphabetic,
    Widget? divider,
    List<Widget> children = const [],
  }) => WFlex._(
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
    direction: Axis.horizontal,
    divider: divider,
    children: children,
  );

  factory WFlex.column({
    MainAxisAlignment mainAxisAlignment = .start,
    MainAxisSize mainAxisSize = .max,
    CrossAxisAlignment crossAxisAlignment = .center,
    TextDirection textDirection = .ltr,
    VerticalDirection verticalDirection = .down,
    TextBaseline textBaseline = .alphabetic,
    Widget? divider,
    List<Widget> children = const [],
  }) => WFlex._(
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
    direction: Axis.vertical,
    divider: divider,
    children: children,
  );

  WFlex _copyWith({
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
    Axis? direction,
    Widget? divider,
    List<Widget>? children,
  }) => WFlex._(
    mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
    mainAxisSize: mainAxisSize ?? this.mainAxisSize,
    crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
    textDirection: textDirection ?? this.textDirection,
    verticalDirection: verticalDirection ?? this.verticalDirection,
    textBaseline: textBaseline ?? this.textBaseline,
    direction: direction ?? this.direction,
    divider: divider ?? this.divider,
    children: children ?? this.children,
  );

  WFlex stretched() =>
      _copyWith(crossAxisAlignment: CrossAxisAlignment.stretch);

  WFlex withDivider(Widget divider) => _copyWith(divider: divider);

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline textBaseline;
  final Axis direction;
  final Widget? divider;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final divider = this.divider;

    return Flex(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      direction: direction,
      children: [
        ...children.expand(
          (child) => <Widget>[
            child,
            if (divider != null && child != children.last) divider,
          ],
        ),
      ],
    );
  }
}
