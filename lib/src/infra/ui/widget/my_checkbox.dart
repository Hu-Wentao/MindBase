import 'package:flutter/material.dart';

class MyCheckBox extends StatefulWidget{

  bool flag;
  MyCheckBox({this.flag=false});

  @override
  State<StatefulWidget> createState() => MyCheckBoxState(this.flag);
}

class MyCheckBoxState extends State{

  bool flag;
  MyCheckBoxState(this.flag);

  @override
  Widget build(BuildContext context) => Checkbox(
      value: this.flag,
      onChanged: (value){
        setState(() {
          this.flag = value!;
        });
        print(flag);
      }
  );
}