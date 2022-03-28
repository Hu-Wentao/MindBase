import 'package:flutter/material.dart';
import 'package:mind_base/src/config/common_config.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataTableEditText extends StatefulWidget {
  const DataTableEditText({
    Key? key,
    required this.editingController,
    // required this.displayText,
    required this.rowColumnIndex,
    required this.column,
    required this.submitCell,
  }) : super(key: key);
  // final String displayText;
   final TextEditingController editingController;
  final RowColumnIndex rowColumnIndex;
  final GridColumn column;
  final CellSubmit submitCell;

  @override
  State<DataTableEditText> createState() => _DataTableEditTextState();
}

class _DataTableEditTextState extends State<DataTableEditText> {
  // late TextEditingController editingController;

  String? newCellValue;

  @override
  void initState() {
    // editingController = TextEditingController(text: widget.displayText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Building a [TextField] for numeric and text column.
    // final bool isTextAlignRight = column.columnName == 'Product No' ||
    //     column.columnName == 'Shipped Date' ||
    //     column.columnName == 'Price';

    // final bool isNumericKeyBoardType =
    //     column.columnName == 'Product No' || column.columnName == 'Price';
    //
    // // Holds regular expression pattern based on the column type.
    // final RegExp regExp = _getRegExp(isNumericKeyBoardType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft, // 文本居左
      // isTextAlignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: widget.editingController,
        // controller: editingController,
        textAlign: TextAlign.left,
        // 文本居左
        // textAlign: isTextAlignRight ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        // 键盘 日间/夜间模式
        // keyboardAppearance: sampleModel.themeData.colorScheme.brightness,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
          // 主题: 下划线
          focusedBorder: UnderlineInputBorder(
              // 主题色
              borderSide: BorderSide(color: Colors.black)),
        ),
        // style: textStyle,
        // cursorColor: sampleModel.backgroundColor,
        // todo 文本格式化输入, 自动过滤字符,只保留数值等等, regex仅仅针对输入的单个字符,如 "[0-9]"表示只能输入数值
        // inputFormatters: <TextInputFormatter>[
        //   FilteringTextInputFormatter.allow(regExp)
        // ],
        keyboardType: TextInputType.text,
        // todo 输入类型
        // isNumericKeyBoardType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          // print("debug #onchange # $value");
          if (value.isNotEmpty) {
            // if (isNumericKeyBoardType) {
            //   newCellValue = column.columnName == 'Price'
            //       ? double.parse(value)
            //       : int.parse(value);
            // } else {
            //   newCellValue = value;
            // }
            newCellValue = value;
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          slLogger.info("buildEditWidget:onSubmitted# $value");

          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          widget.submitCell();
        },
      ),
    );
  }
}
