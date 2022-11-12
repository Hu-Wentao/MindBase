import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? press;
  final Color color, textColor;

  const RoundedButton({
    Key? key,
    required this.text,
    this.press,
    required this.color, // Theme.of(context).primaryColor
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(29),
            child: TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                  (s) =>
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => color,
                ),
              ),
              onPressed: press,
              child: Text(
                text,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ),
      );
}
