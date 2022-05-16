import 'package:flutter/material.dart';

class RadiusInkWell extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;

  const RadiusInkWell({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: child,
        ),
        onTap: onTap,
      );
}
