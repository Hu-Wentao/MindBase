import 'package:flutter/material.dart';

class MainColumn extends StatelessWidget {
  final ScrollController? controller;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;

  const MainColumn({
    Key? key,
    this.controller,
    this.padding = const EdgeInsets.all(8.0),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SafeArea(
      child: SingleChildScrollView(
        controller: controller ?? ScrollController(),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          ),
        ),
      ),
    );
}
