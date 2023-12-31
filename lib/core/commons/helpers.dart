import 'package:intl/intl.dart';
import 'package:listme/crud/models/folder.dart';
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

  static List<Folder> sortFoldersByDateTime({required List<Folder> folders}) {
    folders.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    folders = folders.reversed.toList();
    return folders;
  }
}
