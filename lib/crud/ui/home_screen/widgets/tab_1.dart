import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/ui/home_screen/widgets/categories_expansion_list.dart';

class TabUno extends StatelessWidget {
  const TabUno({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITULO - CATEGORIAS //
          const SizedBox(height: 10),

          // EXPANSION //
          ValueListenableBuilder(
            valueListenable: Hive.box<ListCategory>(AppConstants.categoriesDb).listenable(),
            builder: (context, Box<ListCategory> categories, child) {
              // no lists
              if (categories.values.isEmpty) {
                return const Center(
                  child: Text("No hay categorias"),
                );
              }
              // iterate catgs
              return CategoriesExpansionList(
                categories: categories.values.toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
