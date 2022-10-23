import 'package:flutter/material.dart';
import 'package:mind_base/src/user/infra/ui/widget/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const RoundedPasswordField({
    Key? key,
    this.hintText,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool canObs = false;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: !canObs,
        onChanged: widget.onChanged,
        cursorColor: Theme.of(context).primaryColor,
        validator: widget.validator,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          ),
          suffixIcon: IconButton(
              icon: const Icon(Icons.visibility),
            color: Theme.of(context).primaryColor,
            onPressed: () => setState(() => canObs = !canObs),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
