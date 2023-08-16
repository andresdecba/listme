import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/ui/home_screen/widgets/categories_expansion_list.dart';

class TabUno extends StatefulWidget {
  const TabUno({
    super.key,
  });

  @override
  State<TabUno> createState() => _TabUnoState();
}

class _TabUnoState extends State<TabUno> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 350)).then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.cyan,
        ),
      );
    }

    return ValueListenableBuilder(
      valueListenable: Hive.box<ListCategory>(AppConstants.categoriesDb).listenable(),
      builder: (context, Box<ListCategory> categories, child) {
        //  no lists
        // TODO si no hay categorias poner una imagen svg
        if (categories.values.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text("No hay categorias"),
            ),
          );
        }

        // iterate catgs
        return CategoriesExpansionList(
          categories: categories.values.toList(),
        );
      },
    );
  }
}
