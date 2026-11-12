import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart' show immutable;

/// A calendar day: a date without a time of day or a time zone.
///
/// Stored as the number of days since 1970-01-01, so days compare and count
/// with plain integer arithmetic. A day ends at local midnight on the
/// device; [Day.fromLocal] picks the date the device shows at that moment.
///
/// Moments in time (when a chapter was opened) are `DateTime` in UTC, not
/// [Day].
@immutable
final class Day implements Comparable<Day> {
  /// The day with the given calendar date.
  factory Day(int year, int month, int day) => Day.fromNumber(
    DateTime.utc(year, month, day).millisecondsSinceEpoch ~/ _msPerDay,
  );

  /// The day with the given [number] of days since 1970-01-01.
  const Day.fromNumber(this.number);

  /// The date that [moment] has in the device's local time zone.
  factory Day.fromLocal(DateTime moment) {
    final local = moment.toLocal();
    return Day(local.year, local.month, local.day);
  }

  /// The device's current date, read from `clock`.
  factory Day.today() => Day.fromLocal(clock.now());

  static const int _msPerDay = Duration.millisecondsPerDay;

  /// Days since 1970-01-01.
  final int number;

  DateTime get _utcMidnight =>
      DateTime.fromMillisecondsSinceEpoch(number * _msPerDay, isUtc: true);

  /// The calendar year.
  int get year => _utcMidnight.year;

  /// The month, 1 to 12.
  int get month => _utcMidnight.month;

  /// The day of the month, 1 to 31.
  int get day => _utcMidnight.day;

  /// The day [days] later.
  Day operator +(int days) => Day.fromNumber(number + days);

  /// The day [days] earlier.
  Day operator -(int days) => Day.fromNumber(number - days);

  /// Days from [other] to this day; negative when this day is earlier.
  int difference(Day other) => number - other.number;

  /// Whether this day comes before [other].
  bool isBefore(Day other) => number < other.number;

  /// Whether this day comes after [other].
  bool isAfter(Day other) => number > other.number;

  @override
  int compareTo(Day other) => number.compareTo(other.number);

  @override
  bool operator ==(Object other) => other is Day && other.number == number;

  @override
  int get hashCode => number.hashCode;

  @override
  String toString() {
    String two(int n) => n.toString().padLeft(2, '0');
    return '$year-${two(month)}-${two(day)}';
  }
}
