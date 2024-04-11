class DirectionDetailsInfo{
  int? distance_value;
  int? duration_value;
  String? e_points;
  String? distance_text;
  String? duration_text;


  DirectionDetailsInfo({this.distance_value,this.duration_value,this.distance_text,this.duration_text,this.e_points});

  String getDistanceString() {
    if (distance_value != null) {
      double distanceInKm = distance_value! / 1000; // Convert meters to kilometers
      return "${distanceInKm.toStringAsFixed(2)} km"; // Display distance with 2 decimal places
    } else {
      return "Distance not available";
    }
  }

  String getDurationString() {
    if (duration_value != null) {
      int hours = duration_value! ~/ 3600; // Calculate hours
      int minutes = (duration_value! % 3600) ~/ 60; // Calculate minutes
      return "$hours hr $minutes min"; // Display duration in hours and minutes
    } else {
      return "Duration not available";
    }
  }
}
