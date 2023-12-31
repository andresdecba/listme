import 'package:flutter/material.dart';
import 'package:listme/core/commons/typedefs.dart';

class ListTitle extends StatefulWidget {
  const ListTitle({
    required this.initialValue,
    required this.onEditingComplete,
    this.editModeStyle,
    this.regularModeStyle,
    this.centerTxt = true,
    super.key,
  });

  final String initialValue;
  final ReturnText onEditingComplete;
  final TextStyle? editModeStyle;
  final TextStyle? regularModeStyle;
  final bool centerTxt;

  @override
  State<ListTitle> createState() => _ListTitleState();
}

class _ListTitleState extends State<ListTitle> {
  late FocusNode _focusNode;
  late TextEditingController _textCtr;
  late bool _isEditMode;
  late GlobalKey<FormState> _formStateKey;

  @override
  void initState() {
    super.initState();
    _textCtr = TextEditingController(text: widget.initialValue);
    _formStateKey = GlobalKey<FormState>();
    _focusNode = FocusNode();
    _isEditMode = false;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle editModeStyle = Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 25, color: Colors.grey);
    final TextStyle regularModeStyle = Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 25, color: Colors.black);

    return Form(
      key: _formStateKey,
      child: TextFormField(
        focusNode: _focusNode,
        controller: _textCtr,
        autofocus: false,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        style: _isEditMode ? widget.editModeStyle ?? editModeStyle : widget.regularModeStyle ?? regularModeStyle,
        textAlign: widget.centerTxt
            ? _isEditMode
                ? TextAlign.left
                : TextAlign.center
            : _isEditMode
                ? TextAlign.left
                : TextAlign.left,

        // VALIDATE //
        maxLines: null,
        maxLength: 50,
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Tile must have between 1 and 50 characters';
          } else {
            return null;
          }
        },

        // DECORATION //
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          isDense: true,
          border: InputBorder.none,
          counterText: "",
          filled: false,
          suffixIcon: _isEditMode
              ? InkWell(
                  onTap: () => _textCtr.clear(),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),

        // ACTIONS //
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
          if (_formStateKey.currentState!.validate()) {
            setState(() {
              widget.onEditingComplete(_textCtr.text);
              _isEditMode = false;
              _focusNode.unfocus();
            });
          }
        },
      ),
    );
  }
}
