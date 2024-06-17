import 'package:intl/intl.dart';

class DateUtil {
  static const int SECOND_MILLIS = 1000;
  static const int MINUTE_MILLIS = SECOND_MILLIS * 60;
  static const int HOUR_MILLIS = MINUTE_MILLIS * 60;
  static const int DAY_MILLIS = HOUR_MILLIS * 24;
  static const int WEEK_MILLIS = DAY_MILLIS * 7;
  static const int MONTH_MILLIS = DAY_MILLIS * 30;
  static const int YEAR_MILLIS = MONTH_MILLIS * 12;

  static const _shortServerFormat = "yyyy-MM-dd";

  static DateTime getDateFromCurrent() => DateTime.now();

  static DateTime getDateFromShortServerFormat(String date) =>
      DateFormat(_shortServerFormat).parse(date);

  static String getShortServerFormatDateString(DateTime date) =>
      DateFormat(_shortServerFormat).format(date);

  static String getBirthDate(DateTime date) =>
      DateFormat("dd MMMM yyyy", "en_EN").format(date.toLocal());

  static String getTimeAgo(DateTime date) {
    var time = date.millisecondsSinceEpoch;
    if (time < 1000000000000) {
      // if timestamp given in seconds, convert to millis
      time *= 1000;
    }
    final now = DateTime.now().millisecondsSinceEpoch;

    if (time > now || time <= 0) {
      return "";
    }
    final diff = now - time;
    if (diff < MINUTE_MILLIS) {
      return "just now";
    } else if (diff < 1 * HOUR_MILLIS) {
      int minute = diff ~/ MINUTE_MILLIS;
      return "$minute minute${minute > 1 ? 's' : ''} ago";
    } else if (diff < 1 * DAY_MILLIS) {
      int hour = diff ~/ HOUR_MILLIS;
      return "$hour hour${hour > 1 ? 's' : ''} ago";
    } else if (diff < 1 * WEEK_MILLIS) {
      int day = diff ~/ DAY_MILLIS;
      return day < 2 ? 'yesterday' : '$day days ago';
    } else if (diff < 1 * MONTH_MILLIS) {
      int week = diff ~/ WEEK_MILLIS;
      return "$week week${week > 1 ? 's' : ''} ago";
    } else if (diff < 1 * YEAR_MILLIS) {
      int month = diff ~/ MONTH_MILLIS;
      return "$month month${month > 1 ? 's' : ''} ago";
    } else {
      int year = diff ~/ YEAR_MILLIS;
      return "$year year${year > 1 ? 's' : ''} ago";
    }
  }
}
