import 'package:flutter/material.dart';
import 'package:mind_base/src/core/infra/ui/widget/RadiusInkWell.dart';

class SpaceSelectorBar extends StatelessWidget {
  final Widget spaceName;
  final Widget menuBtn;

  const SpaceSelectorBar({
    Key? key,
    required this.spaceName,
    required this.menuBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RadiusInkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            spaceName,
            const SizedBox(width: 8),
            menuBtn,
          ],
        ),
      );
}
