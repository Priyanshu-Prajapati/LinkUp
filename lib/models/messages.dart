import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat('HH:mm');
final dateFormatter = DateFormat('MMM d y');
final uuid = Uuid();

class Message {
  Message({
    required this.id,
    required this.message,
    required this.email,
    required this.date,
  });

  final String id;
  final String message;
  final String email;
  final DateTime date;

  String get formatedTime {
    return formatter.format(date);
  }

  String get formatedDate {
    return dateFormatter.format(date);
  }
}
