import 'package:flutter/material.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';

class Booorar extends StatefulWidget {
  const Booorar({super.key});

  @override
  State<Booorar> createState() => _BooorarState();
}

class _BooorarState extends State<Booorar> {
  final emptyList = Lista(
    title: "lista vacía",
    creationDate: DateTime.now(),
    items: [],
    id: 'lalalala',
    isCompleted: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.bottomCenter,
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Colors.cyan,
          child: TextField(emptyList: emptyList),
        ),
      ),
    );
  }
}

class TextField extends StatelessWidget {
  const TextField({
    super.key,
    required this.emptyList,
  });

  final Lista emptyList;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CustomTextfield(
            onTap: () {},
            onEditingComplete: (p0) {},
          ),
        ),
      ),
    );
  }
}


/*
child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                alignment: Alignment.bottomCenter,
                height: 1000,
                width: double.infinity,
                color: Colors.cyan,
                child: const Center(
                  child: Text('AAAAAAAAAAAAAA'),
                ),
              ),
            ),
            TextField(emptyList: emptyList),
          ],
        ),
*/