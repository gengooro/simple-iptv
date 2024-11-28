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

  static String minutesToTimeString(int minutes) {
    if (minutes < 0) return "Invalid input";

    final int hours = minutes ~/ 60; // Get the number of hours
    final int remainingMinutes = minutes % 60; // Get the remaining minutes

    // Construct the formatted string
    final String hoursText = hours > 0 ? "${hours}h" : "";
    final String minutesText =
        remainingMinutes > 0 ? "${remainingMinutes}m" : "";

    // Combine the strings with a space
    return [hoursText, minutesText].where((text) => text.isNotEmpty).join(" ");
  }
}
