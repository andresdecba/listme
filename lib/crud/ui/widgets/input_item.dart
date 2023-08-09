import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// class InputItem extends StatelessWidget {
//   const InputItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // FORM
//               _CreateTaskForm(
//                 onEditingComplete: () {},
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class InputItem extends StatefulWidget {
  const InputItem({
    required this.returnText,
    Key? key,
  }) : super(key: key);

  final ReturnText returnText;

  @override
  State<InputItem> createState() => _InputItemState();
}

class _InputItemState extends State<InputItem> {
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 25),
      child: Form(
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
          maxLength: 100,
          validator: (value) {
            if (value != null && value.length < 3) {
              return 'Between 3 and 100 characters';
            } else {
              return null;
            }
          },
          onEditingComplete: () {
            widget.returnText(textController.text);
            context.pop();
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            isDense: true,
            border: const OutlineInputBorder(),
            hintText: 'description',
            // styles
            // hintStyle: kBodySmall.copyWith(fontStyle: FontStyle.italic, color: disabledGrey, fontWeight: FontWeight.normal, fontSize: 13),
            // helperStyle: kBodySmall.copyWith(fontStyle: FontStyle.italic, color: disabledGrey, fontWeight: FontWeight.normal),
            // errorStyle: kBodySmall.copyWith(fontStyle: FontStyle.italic, color: disabledGrey, fontWeight: FontWeight.normal),
            // counterStyle: kBodySmall.copyWith(
            //   fontStyle: FontStyle.italic,
            //   fontWeight: controller.counter.value < 6 ? FontWeight.bold : FontWeight.normal,
            //   color: controller.counter.value < 6 ? warning : disabledGrey,
            // ),
            // others
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
            suffixIconConstraints: const BoxConstraints(maxHeight: 100),
            filled: true,
            fillColor: Colors.grey.shade200,
            counterText: "$counter",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            helperText: 'between 3 and 100 characters',
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
          ),
        ),
      ),
    );
  }
}

typedef ReturnText = void Function(String);
