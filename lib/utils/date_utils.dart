import 'package:intl/intl.dart';

DateTime parseSmartFridgeDate(String value) {
  final normalized = value.replaceAll(' T', 'T');
  final parsed = DateTime.tryParse(normalized);
  if (parsed != null) {
    return parsed;
  }
  try {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS").parse(normalized);
  } catch (_) {
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}

int daysSince(String value) {
  final input = parseSmartFridgeDate(value);
  final now = DateTime.now();
  final inputDate = DateTime(input.year, input.month, input.day);
  final nowDate = DateTime(now.year, now.month, now.day);
  return nowDate.difference(inputDate).inDays;
}

String relativeTime(String value) {
  final input = parseSmartFridgeDate(value);
  final now = DateTime.now();
  final minutes = now.difference(input).inMinutes;
  if (minutes < 60) {
    return '$minutes menit';
  }
  final hours = now.difference(input).inHours;
  return '$hours jam';
}
