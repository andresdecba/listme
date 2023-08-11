import 'package:intl/intl.dart';

class Helpers {
  static String longDateFormater(DateTime date) {
    // sábado, 26/01/2023
    return "${DateFormat('EEEE').format(date)}, ${DateFormat.yMd().format(date)}";
  }
}
