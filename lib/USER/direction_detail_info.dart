class DirectionsDetailinfo{
  int? distance_value;
  int? duration_value;
  List<dynamic>? e_points; // Updated to store coordinates as a list
  String?distance_text;
  String?duration_text;

  DirectionsDetailinfo({
    this.distance_value,
    this.duration_value,
    this.e_points,
    this.distance_text,
    this.duration_text,
  });

}