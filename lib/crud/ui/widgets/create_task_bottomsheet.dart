import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void createTaskBottomSheet({
  required BuildContext context,
  required Widget child,
  bool enableDrag = true,
  bool showClose = false,
  VoidCallback? onClose,
}) {
  showModalBottomSheet<dynamic>(
    isDismissible: false,
    //showDragHandle: enableDrag,
    enableDrag: enableDrag,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    useSafeArea: true,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Visibility(
                visible: showClose,
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              child, /////////// <- child
            ],
          ),
        ),
      );
    },
  ).then((void value) {
    onClose != null ? onClose() : null;
    print(' hahahaha si se cerró el BottomSheet');
  });
}

//() => Get.find<CreateTaskPageController>().closeAndRestoreValues(), print('hohohho si se cerró')