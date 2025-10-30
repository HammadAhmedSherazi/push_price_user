class CalenderDataModel {
  final DateTime date;
  final String title;
  final String description;
  final bool isHoliday;

  const CalenderDataModel({
    required this.date,
    required this.title,
    required this.description,
    this.isHoliday = false,
  });

  factory CalenderDataModel.fromJson(Map<String, dynamic> json) {
    return CalenderDataModel(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isHoliday: json['is_holiday'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'is_holiday': isHoliday,
    };
  }

  CalenderDataModel copyWith({
    DateTime? date,
    String? title,
    String? description,
    bool? isHoliday,
  }) {
    return CalenderDataModel(
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      isHoliday: isHoliday ?? this.isHoliday,
    );
  }
}
