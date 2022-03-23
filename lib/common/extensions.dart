import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  bool get isToday {
    return difference(DateTime.now()).inDays == 0;
  }

  bool get isThisWeek {
    return difference(DateTime.now()).inDays < 7;
  }

  String toRelative() {
    switch (difference(DateTime.now()).inDays) {
      case -1:
        return 'Yesterday';
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      default:
        return '${DateFormat('E').format(this)}, ${DateFormat('MMMd').format(this)}, ${DateFormat('Hm').format(this)}';
    }
  }
}
