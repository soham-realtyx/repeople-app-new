
import 'package:intl/intl.dart';

String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
  // print(dateString);
  DateTime notificationDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString);
  final date2 = DateTime.now();
  final difference = date2.difference(notificationDate);
  if (difference.inDays > 3 && difference.inDays<=365) {
    return DateFormat('MMM dd, HH:mm').format(DateTime.parse(dateString)).toString();
    // return DateFormat('dd-MMM-yyyy | hh:mm a').format(DateTime.parse(dateString)).toString();
  }
  // else if ((difference.inDays / 7).floor() >= 1) {
  //   return (numericDates) ? '1 week ago' : 'Last week';
  // }
  else if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays >= 1) {
    return (numericDates) ? '1 day ago' : 'Yesterday';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours >= 1) {
    return (numericDates) ? '1 hour ago' : 'An hour ago';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes >= 1) {
    return (numericDates) ? '1 minute ago' : 'A minute ago';
  } else if (difference.inSeconds >= 3) {
    return '${difference.inSeconds} seconds ago';
  } else {
    return 'Just now';
  }
}