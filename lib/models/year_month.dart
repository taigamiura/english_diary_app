class YearMonth {
  final int year;
  final int month;

  const YearMonth(this.year, this.month);

  factory YearMonth.fromDateTime(DateTime dt) => YearMonth(dt.year, dt.month);

  factory YearMonth.parse(String value) {
    // "2025-04" 形式にも対応
    final parts = value.split('-');
    if (parts.length >= 2) {
      try {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);

        // 有効な年月の範囲をチェック
        if (year < 1 || year > 9999) {
          throw FormatException('Invalid year: $year');
        }
        if (month < 1 || month > 12) {
          throw FormatException('Invalid month: $month');
        }

        return YearMonth(year, month);
      } catch (e) {
        // int.parseが失敗した場合もFormatExceptionをスロー
        if (e is FormatException) rethrow;
        throw FormatException('Invalid date format $value');
      }
    }
    // fallback: ISO8601
    final dt = DateTime.tryParse(value);
    if (dt != null) return YearMonth(dt.year, dt.month);
    throw FormatException('Invalid date format $value');
  }

  factory YearMonth.fromString(String value) => YearMonth.parse(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YearMonth && year == other.year && month == other.month;

  @override
  int get hashCode => year.hashCode ^ month.hashCode;

  @override
  String toString() => '$year-$month';

  int compareTo(YearMonth other) {
    if (year != other.year) {
      return year.compareTo(other.year);
    }
    return month.compareTo(other.month);
  }
}
