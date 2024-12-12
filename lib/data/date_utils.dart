class MyDateUtils {
  static String getExpirationText(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now);

    if (difference.inDays > 0) {
      return "Expires in ${difference.inDays} days";
    } else if (difference.inSeconds > 0) {
      final hours = difference.inHours;
      final minutes = (difference.inMinutes % 60);
      return "Expires in ${hours}h ${minutes}m";
    } else {
      return "Expired";
    }
  }

  static DateTime unixTimeToDateTime(int unixTime) {
    return DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
  }

  static int dateTimeToUnixTime(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }

  static String? minutesToTimeString(int? minutes) {
    if (minutes == null) return "Invalid input";
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
