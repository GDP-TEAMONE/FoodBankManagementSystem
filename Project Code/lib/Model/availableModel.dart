class AvailableModel {
  DateTime start, end;
  double longitude, latitude;
  String uid, id, name;

  AvailableModel(
      {required this.id,
      required this.name,
      required this.start,
      required this.longitude,
      required this.latitude,
      required this.end,
      required this.uid});
}
