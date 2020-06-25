import 'package:intl/intl.dart';

String getCurrentDate() {
  return DateFormat('dd-MM-yyyy').format(DateTime.now());
}
