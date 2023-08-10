import 'package:flutter/material.dart';
import 'package:listme/core/constants/typedefs.dart';

class ListTitle extends StatefulWidget {
  ListTitle({
    required this.initialValue,
    required this.returnText,
    super.key,
  });

  // params
  final String initialValue;
  final ReturnText returnText;

  @override
  State<ListTitle> createState() => _ListTitleState();
}

class _ListTitleState extends State<ListTitle> {
  // properties
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textCtr = TextEditingController();
  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    final editModeStyle = Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 32, color: Colors.grey);
    final regularModeStyle = Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 32, color: Colors.black);

    _textCtr.text = widget.initialValue;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        focusNode: _focusNode,
        controller: _textCtr,
        autofocus: false,
        canRequestFocus: true,
        maxLines: null,
        maxLength: 200,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        //
        style: _isEditMode ? editModeStyle : regularModeStyle,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          isDense: true,
          border: InputBorder.none,
          counterText: "",
        ),
        onTap: () {
          setState(() {
            _isEditMode = true;
          });
        },
        onTapOutside: (event) {
          setState(() {
            _isEditMode = false;
            _focusNode.unfocus();
          });
        },
        onEditingComplete: () {
          setState(() {
            widget.returnText(_textCtr.text);
            _isEditMode = false;
            _focusNode.unfocus();
          });
        },
      ),
    );
  }
}
