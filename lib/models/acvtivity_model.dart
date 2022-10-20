import 'package:bestrun/models/lap.dart';

class Activity {
  String? date;
  String? time;
  double? distance;
  List<Lap> checkpoints;
  String? average;
  String? imageCode;

  Activity(
      {this.date,
      this.time,
      this.distance,
      required this.checkpoints,
      this.average,
      this.imageCode});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      date: json['date'],
      time: json['time'],
      distance: json['distance'] == 0 ? 0.0 : json['distance'],
      checkpoints:
          List<Lap>.from(json["checkpoints"].map((lap) => Lap.fromJson(lap))),
      average: json['average'],
      imageCode: json['imageCode'],
    );
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': date,
        'time': time,
        'distance': distance,
        'checkpoints':
            List<dynamic>.from(checkpoints.map((lap) => lap.toJson())),
        'average': average,
        'imageCode': imageCode,
      };
}
