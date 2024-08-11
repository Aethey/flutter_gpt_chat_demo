class AppUtils {
  AppUtils._privateConstructor();

  static final AppUtils _instance = AppUtils._privateConstructor();

  static AppUtils get instance => _instance;

  String formatDateRelativeToToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final twoDaysAgo = DateTime(now.year, now.month, now.day - 2);
    final aWeekAgo = DateTime(now.year, now.month, now.day - 7);

    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) {
      return 'Today';
    } else if (dateToCompare == yesterday) {
      return 'Yesterday';
    } else if (dateToCompare == twoDaysAgo) {
      return 'Two days ago';
    } else if (dateToCompare.isAfter(aWeekAgo) &&
        dateToCompare.isBefore(yesterday)) {
      return 'Last week';
    } else {
      return 'Earlier';
    }
  }

  Map<String, DateTime> getDateRangeForLabel(String label) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate =
        DateTime(now.year, now.month, now.day, 23, 59, 59); // end of the day

    switch (label) {
      case "Today":
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case "2 days ago":
        startDate =
            DateTime(now.year, now.month, now.day).subtract(Duration(days: 7));
        endDate =
            DateTime(now.year, now.month, now.day).subtract(Duration(days: 2));
        break;
      case "Last week":
        startDate =
            DateTime(now.year, now.month, now.day).subtract(Duration(days: 30));
        endDate =
            DateTime(now.year, now.month, now.day).subtract(Duration(days: 7));
        break;
      case "Earlier":
        startDate = DateTime(2000, 1, 1); // Arbitrary old date for "Earlier"
        endDate =
            DateTime(now.year, now.month, now.day).subtract(Duration(days: 30));
        break;
      default:
        startDate = now; // Default to today if nothing matches
        break;
    }
    return {'startDate': startDate, 'endDate': endDate};
  }
}
