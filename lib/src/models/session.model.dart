import 'dart:convert';

class Session {
  String bookId;
  DateTime startTime;
  DateTime endTime;
  int pages;
  int minutes;

  Session({
    required this.bookId,
    required this.startTime,
    required this.endTime,
    required this.pages,
    required this.minutes,
  });

  Session copyWith({
    String? id,
    String? bookId,
    DateTime? startTime,
    DateTime? endTime,
    int? pages,
    int? minutes,
  }) {
    return Session(
      bookId: bookId ?? this.bookId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pages: pages ?? this.pages,
      minutes: minutes ?? this.minutes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookId': bookId,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'pages': pages,
      'minutes': minutes,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      bookId: map['bookId'] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      pages: map['pages'] as int,
      minutes: map['minutes'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Session(bookId: $bookId, startTime: $startTime, endTime: $endTime, pages: $pages, minutes: $minutes)';
  }
}
