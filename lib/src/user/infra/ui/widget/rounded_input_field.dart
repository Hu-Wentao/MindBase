import 'package:flutter/material.dart';
import 'package:mind_base/src/user/infra/ui/widget/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final double radius;

  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.validator,
    this.radius = 19,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFieldContainer(
        radius: radius,
        child: TextFormField(
          onChanged: onChanged,
          cursorColor: Theme.of(context).primaryColor,
          validator: validator,
          decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      );
}
