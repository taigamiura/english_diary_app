class YearMonth {
  final int year;
  final int month;

  const YearMonth(this.year, this.month);

  factory YearMonth.fromDateTime(DateTime dt) => YearMonth(dt.year, dt.month);

  factory YearMonth.parse(String value) {
    // "2025-04" 形式にも対応
    final parts = value.split('-');
    if (parts.length >= 2) {
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      return YearMonth(year, month);
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
