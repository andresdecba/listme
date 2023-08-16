import 'package:intl/intl.dart';
import 'package:listme/crud/models/lista.dart';

class Helpers {
  static String longDateFormater(DateTime date) {
    // sábado, 26/01/2023
    return "${DateFormat('EEEE').format(date)}, ${DateFormat.yMd().format(date)}";
  }

  static List<Lista> sortListsByDateTime({required List<Lista> listas}) {
    listas.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    listas = listas.reversed.toList();
    return listas;
  }
}
