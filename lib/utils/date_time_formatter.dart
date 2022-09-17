class DateTimeFormatter {
  static String formatDateTime(DateTime time) {
    return time.year.toString() +
        '/' +
        _convertToTwoDigit(time.month) +
        '/' +
        _convertToTwoDigit(time.day) +
        ' - ' +
        _convertToTwoDigit(time.hour) +
        ':' +
        _convertToTwoDigit(time.minute) +
        ':' +
        _convertToTwoDigit(time.second);
  }

  static String _convertToTwoDigit(int number) {
    String convertedDigit;
    if (number < 10) {
      convertedDigit = "0" + number.toString();
    } else {
      convertedDigit = number.toString();
    }
    return convertedDigit;
  }
}
