import 'package:flutter/material.dart';
import 'package:listme/core/commons/typedefs.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    required this.onEditingComplete,
    required this.onTap,
    this.hintText = 'Description here',
    this.maxCharacters = 120,
    Key? key,
  }) : super(key: key);

  final ReturnText onEditingComplete;
  final VoidCallback onTap;
  final String hintText;
  final int maxCharacters;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late GlobalKey<FormState> formStateKey;
  late FocusNode focusNode;
  late TextEditingController textController;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    formStateKey = GlobalKey<FormState>();
    focusNode = FocusNode();
    textController = TextEditingController();

    textController.addListener(() {
      setState(() {
        counter = textController.text.length;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txtStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FORMULARIO //
        Form(
          key: formStateKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            //textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            focusNode: focusNode,
            autofocus: true,
            controller: textController,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            style: Theme.of(context).textTheme.titleLarge!,
            maxLines: null,
            maxLength: widget.maxCharacters,
            onTap: () {
              widget.onTap();
            },
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Between 1 and ${widget.maxCharacters} characters';
              } else {
                return null;
              }
            },
            onEditingComplete: () {
              if (formStateKey.currentState!.validate()) {
                widget.onEditingComplete(textController.text);
                textController.clear();
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              isDense: true,
              border: const OutlineInputBorder(),
              suffixIconConstraints: const BoxConstraints(maxHeight: 100),
              suffixIcon: counter == 0
                  ? null
                  : InkWell(
                      onTap: () => textController.clear(),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
              // fill color
              filled: true,
              fillColor: Colors.grey.shade200,
              // error STYLE
              errorText: null,
              errorStyle: txtStyle.bodyMedium!.copyWith(color: Colors.red.shade800, fontStyle: FontStyle.italic),
              // hint STYLE
              hintText: widget.hintText,
              hintStyle: txtStyle.bodyLarge!.copyWith(color: Colors.grey.shade400, fontStyle: FontStyle.italic),
              // counter STYLE
              counterText: "$counter",
              counterStyle: txtStyle.bodyMedium!.copyWith(color: Colors.grey.shade400, fontStyle: FontStyle.italic),
              // helper STYLE
              helperText: 'between 1 and ${widget.maxCharacters} characters',
              helperStyle: txtStyle.bodyMedium!.copyWith(color: Colors.grey.shade400, fontStyle: FontStyle.italic),
              // enabled BORDERS
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              // error BORDERS
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
