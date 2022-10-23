import 'package:flutter/material.dart';

class RadiusInkWell extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final Widget child;
  final GestureTapCallback? onTap;
  final BorderRadius borderRadius;

  const RadiusInkWell({
    Key? key,
    required this.child,
    this.onTap,
    this.margin = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: InkWell(
          borderRadius: borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: child,
          ),
          onTap: onTap,
        ),
      );
}
