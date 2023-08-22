import 'package:flutter/material.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen/widgets/drawer_page_dos.dart';
import 'package:listme/crud/ui/crud_screen/widgets/drawer_page_uno.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class CrudDrawer extends StatefulWidget {
  const CrudDrawer({
    super.key,
    required this.lista,
  });

  final Lista lista;

  @override
  State<CrudDrawer> createState() => _CrudDrawerState();
}

class _CrudDrawerState extends State<CrudDrawer> {
  late CrudUseCases useCases;
  late PageController pageCtlr;
  late int selectedPage;
  late List<Folder> folders;

  @override
  void initState() {
    super.initState();
    useCases = CrudUseCasesImpl();
    pageCtlr = PageController();
    selectedPage = 0;
    pageCtlr = PageController(initialPage: selectedPage);
    folders = useCases.getFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: pageCtlr,
                  pageSnapping: true,
                  onPageChanged: (value) {
                    setState(() {
                      selectedPage = value;
                    });
                  },
                  children: [
                    // PAGE UNO //
                    CrudDrawerPageUno(
                      lista: widget.lista,
                      pageCtlr: pageCtlr,
                    ),

                    CrudDrawerPageDos(
                      folders: folders,
                      lista: widget.lista,
                      pageCtlr: pageCtlr,
                    ),
                  ],
                ),
              ),
              PageViewDotIndicator(
                currentItem: selectedPage,
                count: 2,
                size: const Size(8, 8),
                unselectedColor: Colors.black26,
                selectedColor: Colors.cyan,
                duration: const Duration(milliseconds: 200),
                boxShape: BoxShape.circle,
                onItemClicked: (index) {
                  // pageCtlr.animateToPage(
                  //   index,
                  //   duration: const Duration(milliseconds: 200),
                  //   curve: Curves.easeInOut,
                  // );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),

          /*
          child: 
        */
        ),
      ),
    );
  }
}
