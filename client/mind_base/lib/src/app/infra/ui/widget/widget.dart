import 'package:flutter/material.dart';

/// 页面主体Column，包含SafeArea，Padding，ScrollView等配置
class MainColumn extends StatelessWidget {
  final List<Widget> main;
  final List<Widget> bottom;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry padding;
  final ScrollController? controller;
  final bool scroll;

  const MainColumn.dense({
    Key? key,
    List<Widget>? main,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
    List<Widget> bottom = const [],
    List<Widget> children = const [],
    ScrollController? controller,
    bool scroll = true,
  }) : this(
    key: key,
    main: main,
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    padding: padding,
    bottom: bottom,
    children: children,
    controller: controller,
    scroll: scroll,
  );

  const MainColumn({
    Key? key,
    List<Widget>? main,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 36),
    this.bottom = const [],
    List<Widget> children = const [],
    this.controller,
    this.scroll = true,
  })  : assert(
  !(main != null && children.length != 0), "main 与 children 不能同时有值"),
        main = main ?? children,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = scroll ? (this.controller ?? ScrollController()) : null;
    return SafeArea(
      child: Padding(
          padding: padding,
          child: bottom.isEmpty
              ? _buildColumn(context, controller)
              : Column(
            children: [
              Expanded(child: _buildColumn(context, controller)),
              ...bottom,
            ],
          )),
    );
  }

  _buildColumn(BuildContext context, [ScrollController? controller]) {
    final col = Column(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: crossAxisAlignment,
      children: main,
    );
    return controller == null
        ? col
        : SingleChildScrollView(controller: controller, child: col);
  }
}