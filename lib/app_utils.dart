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
}
