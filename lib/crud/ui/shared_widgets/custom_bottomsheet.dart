import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void customBottomSheet({
  required BuildContext context,
  required Widget child,
  bool enableDrag = true,
  bool showClose = false,
  VoidCallback? onClose,
  String? title,
  String? subTitle,
}) {
  final screenSize = MediaQuery.of(context).size;
  final TextTheme style = Theme.of(context).textTheme;

  // MODAL //
  showModalBottomSheet<dynamic>(
    isScrollControlled: true,
    isDismissible: false,
    showDragHandle: false,
    enableDrag: enableDrag,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    useSafeArea: true,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // close btn //
            Visibility(
              visible: showClose,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: const EdgeInsets.all(15),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            // TITLE //
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: style.titleMedium,
                  ),
                ),
              ),
            // SUBTITLE //
            if (subTitle != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    subTitle,
                    style: style.bodyLarge!.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            if (subTitle == null) const SizedBox(height: 10),
            // CHILD //
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: child,
            ),
          ],
        ),
      );
    },
  ).then((void value) {
    onClose != null ? onClose() : null;
    debugPrint('si se cerró el BottomSheet :)');
  });
}

//() => Get.find<CreateTaskPageController>().closeAndRestoreValues(), print('hohohho si se cerró')