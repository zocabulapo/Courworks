class Observation {
  String observationDetail;
  DateTime time;
  String weather;
  String additionalComments;
  String locationDetail;
  String image;
  String hikeName;

  Observation({
    required this.observationDetail,
    required this.time,
    this.weather = "",
    this.additionalComments = "",
    this.locationDetail = "",
    this.image = "",
    required this.hikeName,
  });

  // Hàm factory để tạo đối tượng Observation từ Map (dữ liệu từ cơ sở dữ liệu)
  factory Observation.fromMap(Map<String, dynamic> map) {
    return Observation(
      observationDetail: map['observationDetail'],
      time: DateTime.parse(map['time']),
      weather: map['weather'],
      additionalComments: map['additionalComments'],
      locationDetail: map['locationDetail'],
      image: map['image'],
      hikeName: map['hikeName'],
    );
  }

  // Phương thức để chuyển đối tượng Observation thành Map (để lưu vào cơ sở dữ liệu)
  Map<String, dynamic> toMap() {
    return {
      'observationDetail': observationDetail,
      'time': time.toIso8601String(),
      'weather': weather,
      'additionalComments': additionalComments,
      'locationDetail': locationDetail,
      'image': image,
      'hikeName': hikeName,
    };
  }
}
