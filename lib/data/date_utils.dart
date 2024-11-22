class MyDateUtils {
  static int getDaysLeft(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now);
    return difference.inDays;
  }

  static DateTime unixTimeToDateTime(int unixTime) {
    return DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
  }

  static int dateTimeToUnixTime(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }
}
