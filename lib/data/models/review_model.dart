class ReviewModel {
  final String id;
  final String doctorId;
  final String userName;
  final String date;
  final double rating;
  final String comment;
  final String avatar;

  const ReviewModel({
    required this.id,
    required this.doctorId,
    required this.userName,
    required this.date,
    required this.rating,
    required this.comment,
    required this.avatar,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      userName: json['userName'] as String,
      date: json['date'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      avatar: json['avatar'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'userName': userName,
      'date': date,
      'rating': rating,
      'comment': comment,
      'avatar': avatar,
    };
  }

  ReviewModel copyWith({
    String? id,
    String? doctorId,
    String? userName,
    String? date,
    double? rating,
    String? comment,
    String? avatar,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      userName: userName ?? this.userName,
      date: date ?? this.date,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReviewModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

