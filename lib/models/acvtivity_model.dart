import 'package:bestrun/models/lap.dart';

class Activity {
  String? date;
  String? time;
  double? distance;
  List<Lap> checkpoints;
  String? average;
  String? activityName;
  int? temperature;
  String? weatherCondition;
  String? imageCode;

  Activity(
      {this.date,
      this.time,
      this.distance,
      required this.checkpoints,
      this.average,
      this.activityName,
      this.temperature,
      this.weatherCondition,
      this.imageCode});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      date: json['date'],
      time: json['time'],
      distance: json['distance'] == 0 ? 0.0 : json['distance'],
      checkpoints:
          List<Lap>.from(json["checkpoints"].map((lap) => Lap.fromJson(lap))),
      average: json['average'],
      activityName: json['activityName'],
      temperature: json['temperature'],
      weatherCondition: json['weatherCondition'],
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
        'activityName': activityName,
        'temperature': temperature,
        'weatherCondition': weatherCondition,
        'imageCode': imageCode,
      };
}
