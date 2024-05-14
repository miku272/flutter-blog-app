import 'package:intl/intl.dart';

String formatDatedMMYYYY(DateTime dateTime) {
  return DateFormat('dd MMM yyyy').format(dateTime);
}
