import 'package:bestrun/models/lap.dart';

class MyActivityListItem {
  final String? date;
  final String? time;
  final String? distance;
  final String? numberOfCheckPoints;
  final List<Lap>? checkpoints;
  final double? average;

  MyActivityListItem(
      {this.date,
      this.time,
      this.distance,
      this.numberOfCheckPoints,
      this.checkpoints,
      this.average});
}
