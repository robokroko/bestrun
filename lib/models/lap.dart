class Lap {
  double? distance;
  String? time;

  Lap({
    this.distance,
    this.time,
  });

  factory Lap.fromJson(Map<String, dynamic> json) => Lap(
        time: json['time'],
        distance: json['distance'] == null || json['distance'] == 0
            ? 0.0
            : json['distance'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'time': time,
        'distance': distance,
      };
}
