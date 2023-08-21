import 'package:intl/intl.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';

class Helpers {
  static String longDateFormater(DateTime date) {
    // sábado, 26/01/2023
    return "${DateFormat.MEd().format(date)}/${DateFormat('yy').format(date)}";
  }

  static List<Lista> sortListsByDateTime({required List<Lista> listas}) {
    listas.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    listas = listas.reversed.toList();
    return listas;
  }

  static List<Category> sortCategoriesByDateTime({required List<Category> categories}) {
    categories.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    categories = categories.reversed.toList();
    return categories;
  }
}
